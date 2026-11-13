#!/usr/bin/env python3
import pathlib
import re
import sys

import registros

VAULT_ROOT = registros.VAULT_ROOT
IGNORED_DIRECTORIES = {"archivo", ".obsidian", ".git", ".trash", ".github"}
REQUIRED_NOTES = [
    "CLAUDE.md",
    "ESTADO.md",
    "AUTORES.md",
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
LINE_BUDGETS = {"CLAUDE.md": 80, "ESTADO.md": 60}
SESSION_NOTE_LINE_BUDGET = 40
RECORD_LINE_BUDGET = 30
NOTES_WITHOUT_VERIFICATION_STAMP = {"CLAUDE.md", "herramientas/LEEME.md", "place/mapa-place.md", "place/valores.md"}
SESSION_DIRECTORY = "bitacora"
SESSION_AUTHORS_WITHOUT_PERSON = {"resumen"}
RECORD_AUTHORS_WITHOUT_PERSON = {"v1"}
REQUIRED_RECORD_FIELDS = ("tipo", "id", "fecha", "autor", "estado")

WIKILINK = re.compile(r"\[\[([^\]|#]+)")
RECORD_REFERENCES = {
    "decision": re.compile(r"\bD-\d{3}[a-z]?\b"),
    "pregunta": re.compile(r"\bQ-\d{2,3}[a-z]?\b"),
    "tarea": re.compile(r"\bT-\d{2,3}[a-z]?\b"),
}
CONFIG_KEY_REFERENCE = re.compile(r"\b((?:GameConfig|EconomyConfig)(?:\.[A-Za-z]+){1,2})")
FINGERPRINT_LINE = re.compile(r"^huella: (.+)$", re.MULTILINE)
GENERATED_DATE = re.compile(r"generado=(\d{4}-\d{2}-\d{2})")
SESSION_NOTE_NAME = re.compile(r"^(\d{4}-\d{2}-\d{2})-([a-z0-9]+)$")
CONFLICT_MARKER = re.compile(r"^(<<<<<<<|>>>>>>>) ", re.MULTILINE)


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
    return registros.split_frontmatter(text)[0].get(key)


def section_lines(text, heading):
    lines = text.splitlines()
    if heading not in lines:
        return []
    collected = []
    for line in lines[lines.index(heading) + 1:]:
        if line.startswith("# "):
            break
        collected.append(line)
    return collected


def is_session_note(name):
    return name.startswith(SESSION_DIRECTORY + "/")


def check_required_notes(report):
    for name in REQUIRED_NOTES:
        if not (VAULT_ROOT / name).is_file():
            report.error(f"falta la nota {name}")


def check_merge_leftovers(notes, report):
    for name, text in notes.items():
        if CONFLICT_MARKER.search(text):
            report.error(f"{name}: tiene marcadores de conflicto de git sin resolver")


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


def check_records(report):
    people = set(registros.author_letters())
    identifiers = {}
    for kind in registros.KINDS.values():
        identifiers[kind.name] = set()
        directory = VAULT_ROOT / kind.directory
        for path in sorted(directory.glob("*.md")):
            if path.name.isupper() or path.stem.isupper():
                continue
            if not path.name.startswith(kind.prefix + "-"):
                report.error(f"{relative(path)}: en esta carpeta solo van registros {kind.prefix}-…; crearlos con nuevo.py")
        for record in registros.load_records(kind):
            name = relative(record.path)
            missing = [field for field in (*REQUIRED_RECORD_FIELDS, kind.group_field) if not record.fields.get(field)]
            if missing:
                report.error(f"{name}: faltan campos en el encabezado: {', '.join(missing)}")
                continue
            identifier = record.identifier
            if not registros.RECORD_ID.match(identifier) or not identifier.startswith(kind.prefix + "-"):
                report.error(f"{name}: id inválido '{identifier}'")
            if not record.path.name.startswith(identifier + "-"):
                report.error(f"{name}: el nombre del archivo no empieza con su id {identifier}")
            if not record.title:
                report.error(f"{name}: falta el título '# {identifier} · …'")
            if identifier in identifiers[kind.name]:
                report.error(f"{name}: id repetido {identifier}; renombrar el registro más nuevo con nuevo.py")
            identifiers[kind.name].add(identifier)
            if record.fields["autor"] not in people | RECORD_AUTHORS_WITHOUT_PERSON:
                report.error(f"{name}: autor '{record.fields['autor']}' no está en AUTORES.md")
            if record.text.count("\n") + 1 > RECORD_LINE_BUDGET:
                report.warn(f"{name}: pasa de {RECORD_LINE_BUDGET} líneas; un registro debe ser corto")
    return identifiers


def check_record_references(notes, identifiers, report):
    for name, text in notes.items():
        for kind_name, pattern in RECORD_REFERENCES.items():
            if kind_name != "decision" and is_session_note(name):
                continue
            for reference in sorted(set(pattern.findall(text)) - identifiers[kind_name]):
                report.error(f"{name}: cita {reference}, que no existe (o ya se cerró)")


def check_fingerprints(notes, report):
    fingerprints = {}
    for name in ("place/mapa-place.md", "place/valores.md"):
        matches = FINGERPRINT_LINE.findall(notes.get(name, ""))
        if len(matches) != 1:
            report.error(f"{name}: debe tener exactamente una línea 'huella:' (tiene {len(matches)}); regenerar")
        else:
            fingerprints[name] = matches[0].strip()
    if len(set(fingerprints.values())) > 1:
        report.error("place/mapa-place.md y place/valores.md tienen huellas distintas: regenerar las dos")


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
        if name == "place/valores.md" or is_session_note(name):
            continue
        for key in sorted(set(CONFIG_KEY_REFERENCE.findall(text))):
            if not config_key_exists(key, values):
                report.error(f"{name}: cita {key}, que no existe en place/valores.md")


def check_session_notes(notes, report):
    people = set(registros.author_letters()) | SESSION_AUTHORS_WITHOUT_PERSON
    latest_date = ""
    for name, text in notes.items():
        if not is_session_note(name):
            continue
        match = SESSION_NOTE_NAME.match(pathlib.PurePosixPath(name).stem)
        if not match:
            report.error(f"{name}: el nombre debe ser AAAA-MM-DD-autor.md; crearla con nuevo.py bitacora")
            continue
        if match.group(2) not in people:
            report.error(f"{name}: autor '{match.group(2)}' no está en AUTORES.md")
        latest_date = max(latest_date, match.group(1))
        if text.count("\n") + 1 > SESSION_NOTE_LINE_BUDGET:
            report.warn(f"{name} pasa de {SESSION_NOTE_LINE_BUDGET} líneas: resumir")
    if not latest_date:
        report.error("no hay notas en bitacora/")
        return
    generated = GENERATED_DATE.search(notes.get("place/mapa-place.md", ""))
    if generated and generated.group(1) < latest_date:
        report.warn(f"place/mapa-place.md se generó el {generated.group(1)} y hay bitácora del {latest_date}; regenerar si se tocó Studio")


def check_stamps_and_budgets(notes, record_paths, report):
    for name, text in notes.items():
        line_count = text.count("\n") + 1
        if name in LINE_BUDGETS and line_count > LINE_BUDGETS[name]:
            report.warn(f"{name} tiene {line_count} líneas (máximo {LINE_BUDGETS[name]}): resumir")
        if is_session_note(name) or name in record_paths or name in NOTES_WITHOUT_VERIFICATION_STAMP:
            continue
        if not frontmatter_value(text, "verificado"):
            report.error(f"{name}: falta 'verificado:' en el encabezado")


def check_archive_manifest(report):
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
    check_required_notes(report)
    check_merge_leftovers(notes, report)
    stems = check_unique_names(notes, report)
    check_wikilinks(notes, stems, report)
    identifiers = check_records(report)
    check_record_references(notes, identifiers, report)
    check_fingerprints(notes, report)
    script_count, tag_count = check_systems_cover_place(notes, report)
    check_level_sheets(notes, report)
    check_config_keys(notes, report)
    check_session_notes(notes, report)
    record_paths = {relative(record.path) for kind in registros.KINDS.values() for record in registros.load_records(kind)}
    check_stamps_and_budgets(notes, record_paths, report)
    check_archive_manifest(report)
    for message in report.errors:
        print("ERROR " + message)
    for message in report.warnings:
        print("AVISO " + message)
    summary = (
        f"{len(notes)} notas, {len(identifiers['decision'])} decisiones, {len(identifiers['pregunta'])} preguntas, "
        f"{len(identifiers['tarea'])} tareas, {script_count} scripts y {tag_count} etiquetas cubiertos"
    )
    if report.errors:
        print(f"FALLA: {len(report.errors)} errores ({summary})")
        sys.exit(1)
    print(f"OK ({summary})")


if __name__ == "__main__":
    main()
