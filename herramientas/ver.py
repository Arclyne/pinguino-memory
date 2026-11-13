#!/usr/bin/env python3
import re
import sys

import registros

FULL_TEXT_MATCH_LIMIT = 3
RECENT_SESSION_NOTES = 3
START_TASK_GROUP = "ahora"


def without_frontmatter(text):
    return registros.split_frontmatter(text)[1].strip()


def show_records(kind, search_term):
    records = registros.load_records(kind)
    if not search_term:
        print("\n".join(record.summary_line for record in records))
        return
    wanted = search_term.lower()
    exact = [record for record in records if record.identifier.lower() == wanted]
    matches = exact or [record for record in records if wanted in record.text.lower()]
    if len(matches) <= FULL_TEXT_MATCH_LIMIT:
        print("\n\n".join(record.text.strip() for record in matches) or "sin resultados")
    else:
        print("\n".join(record.summary_line for record in matches))


def show_start():
    root = registros.VAULT_ROOT
    print(without_frontmatter((root / "ESTADO.md").read_text(encoding="utf-8")))
    fingerprint = re.search(r"^huella: .+$", (root / "place/mapa-place.md").read_text(encoding="utf-8"), re.MULTILINE)
    print("\n## Huella de la place guardada en el vault\n" + (fingerprint.group(0) if fingerprint else "sin huella"))
    print("\n## Bitácoras recientes")
    for path in sorted((root / "bitacora").glob("*.md"))[-RECENT_SESSION_NOTES:]:
        print(without_frontmatter(path.read_text(encoding="utf-8")) + "\n")
    tasks = registros.load_records(registros.KINDS["tarea"])
    print("## Tareas del grupo 'ahora'")
    print("\n".join(task.summary_line for task in tasks if task.group == START_TASK_GROUP) or "ninguna")
    questions = registros.load_records(registros.KINDS["pregunta"])
    by_group = {}
    for question in questions:
        by_group[question.group] = by_group.get(question.group, 0) + 1
    counts = ", ".join(f"{group}: {count}" for group, count in sorted(by_group.items()))
    print(f"\n## Preguntas abiertas: {len(questions)} ({counts})")


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("inicio", *registros.KINDS_BY_PLURAL):
        sys.exit("uso: ver.py inicio | ver.py decisiones|preguntas|tareas [ID o texto]")
    if sys.argv[1] == "inicio":
        show_start()
    else:
        show_records(registros.KINDS_BY_PLURAL[sys.argv[1]], " ".join(sys.argv[2:]))


if __name__ == "__main__":
    main()
