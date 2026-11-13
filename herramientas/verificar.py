#!/usr/bin/env python3
import pathlib
import re
import sys

VAULT_ROOT = pathlib.Path(__file__).resolve().parent.parent
IGNORED_DIRECTORIES = {"archivo", ".obsidian", ".git", ".trash"}
REQUIRED_NOTES = [
    "CLAUDE.md",
    "ESTADO.md",
    "decisiones/REGISTRO.md",
    "diseno/juego.md",
    "diseno/personaje.md",
    "diseno/lobby-economia.md",
    "place/mapa-place.md",
    "place/valores.md",
    "place/sistemas.md",
    "pendientes/PREGUNTAS.md",
    "pendientes/TAREAS.md",
    "herramientas/LEEME.md",
    "archivo/MANIFIESTO.md",
]
LINE_BUDGETS = {"CLAUDE.md": 80, "ESTADO.md": 70}
SESSION_NOTE_LINE_BUDGET = 40
NOTES_WITHOUT_VERIFICATION_STAMP = {"CLAUDE.md", "herramientas/LEEME.md", "place/mapa-place.md", "place/valores.md"}
HISTORICAL_DIRECTORY = "bitacora"

WIKILINK = re.compile(r"\[\[([^\]|#]+)")
DECISION_REFERENCE = re.compile(r"\bD-(\d{3})\b")
QUESTION_REFERENCE = re.compile(r"\bQ-(\d{2})\b")
TASK_REFERENCE = re.compile(r"\bT-(\d{2})\b")
CONFIG_KEY_REFERENCE = re.compile(r"\b((?:GameConfig|EconomyConfig)(?:\.[A-Za-z]+){1,2})")
FINGERPRINT_LINE = re.compile(r"^huella: (.+)$", re.MULTILINE)
GENERATED_DATE = re.compile(r"generado=(\d{4}-\d{2}-\d{2})")
SESSION_NOTE_NAME = re.compile(r"^\d{4}-\d{2}-\d{2}$")


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []

    def error(self, message):
        self.errors.append(message)

    def warn(self, message):
        self.warnings.append(message)


def relative(path):
    return path.relative_to(VAULT_ROOT).as_posix()


def collect_notes():
    notes = {}
    for path in sorted(VAULT_ROOT.rglob("*.md")):
        if IGNORED_DIRECTORIES.intersection(path.relative_to(VAULT_ROOT).parts):
            continue
        notes[relative(path)] = path.read_text(encoding="utf-8")
    return notes


def frontmatter_value(text, key):
    match = re.search(r"^" + re.escape(key) + r":\s*(.+)$", text.split("\n---", 1)[0], re.MULTILINE)
    return match.group(1).strip() if match else None


def section_lines(text, heading):
    lines = text.splitlines()
    if heading not in lines:
        return []
    start = lines.index(heading) + 1
    collected = []
    for line in lines[start:]:
        if line.startswith("# "):
            break
        collected.append(line)
    return collected


def check_required_notes(notes, report):
    for name in REQUIRED_NOTES:
        if not (VAULT_ROOT / name).is_file():
            report.error(f"falta la nota {name}")


def check_unique_names(notes, report):
    seen = {}
    for name in notes:
        stem = pathlib.PurePosixPath(name).stem.lower()
        if stem in seen:
            report.error(f"dos notas con el mismo nombre: {seen[stem]} y {name}")
        seen[stem] = name
    return set(seen)


def check_wikilinks(notes, stems, report):
    for name, text in notes.items():
        for target in WIKILINK.findall(text):
            if pathlib.PurePosixPath(target.strip()).name.lower() not in stems:
                report.error(f"{name}: enlace roto [[{target}]]")


def check_decisions(notes, report):
    registry = notes.get("decisiones/REGISTRO.md", "")
    indexed = set(re.findall(r"^\| D-(\d{3}) \|", registry, re.MULTILINE))
    detailed = set(re.findall(r"^## D-(\d{3}) ·", registry, re.MULTILINE))
    for missing in sorted(indexed - detailed):
        report.error(f"REGISTRO: D-{missing} está en el índice pero no tiene bloque")
    for missing in sorted(detailed - indexed):
        report.error(f"REGISTRO: D-{missing} tiene bloque pero no está en el índice")
    expected = {f"{number:03d}" for number in range(1, len(detailed) + 1)}
    if detailed != expected:
        report.error("REGISTRO: los números de decisión no son consecutivos desde D-001")
    for name, text in notes.items():
        for reference in set(DECISION_REFERENCE.findall(text)) - detailed:
            report.error(f"{name}: cita D-{reference}, que no existe en REGISTRO")
    return detailed


def check_numbered_items(notes, note_name, prefix, reference_pattern, report):
    text = notes.get(note_name, "")
    defined = set(re.findall(r"\*\*" + prefix + r"-(\d{2})\*\*", text))
    next_free = re.search(r"[Ss]iguiente(?: número)? libre: " + prefix + r"-(\d{2})", text)
    if not next_free:
        report.error(f"{note_name}: falta la línea 'siguiente libre: {prefix}-NN'")
    elif defined and int(next_free.group(1)) <= max(int(number) for number in defined):
        report.error(f"{note_name}: el siguiente libre ({prefix}-{next_free.group(1)}) ya está usado")
    for name, other_text in notes.items():
        if name.startswith(HISTORICAL_DIRECTORY + "/"):
            continue
        for reference in sorted(set(reference_pattern.findall(other_text)) - defined):
            if name == note_name and next_free and reference == next_free.group(1):
                continue
            report.error(f"{name}: cita {prefix}-{reference}, que ya no está en {note_name}")
    return defined


def check_fingerprints(notes, report):
    state_fingerprint = frontmatter_value(notes.get("ESTADO.md", ""), "huella")
    for name in ("place/mapa-place.md", "place/valores.md"):
        match = FINGERPRINT_LINE.search(notes.get(name, ""))
        if not match:
            report.error(f"{name}: no tiene línea 'huella:'")
        elif match.group(1).strip() != state_fingerprint:
            report.error(f"{name}: su huella no coincide con la de ESTADO.md (regenerar o actualizar ESTADO)")


def check_systems_cover_place(notes, report):
    place_map = notes.get("place/mapa-place.md", "")
    systems = notes.get("place/sistemas.md", "")
    script_names = []
    for line in section_lines(place_map, "# scripts"):
        if line == "## sin detalle":
            break
        if line and not line.startswith("#"):
            script_names.append(line.split(" ", 1)[0])
    tag_names = [line.split(" ", 1)[0] for line in section_lines(place_map, "# etiquetas") if line]
    for script_name in sorted(set(script_names)):
        if not re.search(r"\b" + re.escape(script_name) + r"\b", systems):
            report.error(f"place/sistemas.md no menciona el script {script_name}")
    for tag_name in sorted(set(tag_names)):
        if not re.search(r"\b" + re.escape(tag_name) + r"\b", systems):
            report.error(f"place/sistemas.md no menciona la etiqueta {tag_name}")
    return len(set(script_names)), len(set(tag_names))


def check_level_sheets(notes, report):
    place_map = notes.get("place/mapa-place.md", "")
    built_levels = set(re.findall(r"^## N(\d+) ", place_map, re.MULTILINE))
    documented_levels = set()
    for name, text in notes.items():
        match = re.fullmatch(r"diseno/nivel-(\d+)\.md", name)
        if not match:
            continue
        documented_levels.add(match.group(1))
        folder = frontmatter_value(text, "folder")
        if not folder or folder.split(".")[-1] not in place_map:
            report.error(f"{name}: su folder ({folder}) no aparece en place/mapa-place.md")
    for level in sorted(built_levels - documented_levels):
        report.error(f"el nivel {level} existe en la place pero no tiene diseno/nivel-{level}.md")
    for level in sorted(documented_levels - built_levels):
        report.warn(f"diseno/nivel-{level}.md describe un nivel que no está en la place")


def config_key_exists(key, values):
    if re.search(r"^" + re.escape(key) + r"[.=:]", values, re.MULTILINE):
        return True
    parent, _, leaf = key.rpartition(".")
    inline_entry = r"^" + re.escape(parent) + r": .*\b" + re.escape(leaf) + r"="
    return re.search(inline_entry, values, re.MULTILINE) is not None


def check_config_keys(notes, report):
    values = notes.get("place/valores.md", "")
    for name, text in notes.items():
        if name == "place/valores.md" or name.startswith(HISTORICAL_DIRECTORY + "/"):
            continue
        for key in sorted(set(CONFIG_KEY_REFERENCE.findall(text))):
            if not config_key_exists(key, values):
                report.error(f"{name}: cita {key}, que no existe en place/valores.md")


def check_dates(notes, report):
    session_dates = sorted(
        pathlib.PurePosixPath(name).stem
        for name in notes
        if name.startswith(HISTORICAL_DIRECTORY + "/") and SESSION_NOTE_NAME.match(pathlib.PurePosixPath(name).stem)
    )
    if not session_dates:
        report.error("no hay notas en bitacora/")
        return
    latest_session = session_dates[-1]
    state = notes.get("ESTADO.md", "")
    if frontmatter_value(state, "ultima_sesion") != latest_session:
        report.error(f"ESTADO.md: ultima_sesion no es la última bitácora ({latest_session})")
    verified = frontmatter_value(state, "verificado") or ""
    if verified[:10] < latest_session:
        report.warn(f"ESTADO.md se verificó el {verified[:10]} y hay bitácora del {latest_session}")
    generated = GENERATED_DATE.search(notes.get("place/mapa-place.md", ""))
    if generated and generated.group(1) < latest_session:
        report.warn(f"place/mapa-place.md se generó el {generated.group(1)}; regenerar si se tocó Studio después")


def check_stamps_and_budgets(notes, report):
    for name, text in notes.items():
        line_count = text.count("\n") + 1
        if name in LINE_BUDGETS and line_count > LINE_BUDGETS[name]:
            report.warn(f"{name} tiene {line_count} líneas (máximo {LINE_BUDGETS[name]}): resumir")
        if name.startswith(HISTORICAL_DIRECTORY + "/"):
            if line_count > SESSION_NOTE_LINE_BUDGET:
                report.warn(f"{name} tiene {line_count} líneas (máximo {SESSION_NOTE_LINE_BUDGET}): resumir")
            continue
        if name not in NOTES_WITHOUT_VERIFICATION_STAMP and not frontmatter_value(text, "verificado"):
            report.error(f"{name}: falta 'verificado:' en el encabezado")


def check_archive_manifest(notes, report):
    archive = VAULT_ROOT / "archivo"
    manifest_path = archive / "MANIFIESTO.md"
    manifest = manifest_path.read_text(encoding="utf-8") if manifest_path.is_file() else ""
    for path in sorted(archive.rglob("*")):
        if path.is_file() and path.name != "MANIFIESTO.md" and path.name not in manifest:
            report.error(f"archivo/MANIFIESTO.md no lista {relative(path)}")
    for listed in re.findall(r"^\| `([^`]+)` \|", manifest, re.MULTILINE):
        if not (archive / listed).is_file():
            report.error(f"archivo/MANIFIESTO.md lista {listed}, que no existe")


def main():
    report = Report()
    notes = collect_notes()
    check_required_notes(notes, report)
    stems = check_unique_names(notes, report)
    check_wikilinks(notes, stems, report)
    decisions = check_decisions(notes, report)
    questions = check_numbered_items(notes, "pendientes/PREGUNTAS.md", "Q", QUESTION_REFERENCE, report)
    tasks = check_numbered_items(notes, "pendientes/TAREAS.md", "T", TASK_REFERENCE, report)
    check_fingerprints(notes, report)
    script_count, tag_count = check_systems_cover_place(notes, report)
    check_level_sheets(notes, report)
    check_config_keys(notes, report)
    check_dates(notes, report)
    check_stamps_and_budgets(notes, report)
    check_archive_manifest(notes, report)
    for message in report.errors:
        print("ERROR " + message)
    for message in report.warnings:
        print("AVISO " + message)
    summary = f"{len(notes)} notas, {len(decisions)} decisiones, {len(questions)} preguntas, {len(tasks)} tareas, {script_count} scripts y {tag_count} etiquetas cubiertos"
    if report.errors:
        print(f"FALLA: {len(report.errors)} errores ({summary})")
        sys.exit(1)
    print(f"OK ({summary})")


if __name__ == "__main__":
    main()
