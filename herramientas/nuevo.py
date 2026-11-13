#!/usr/bin/env python3
import argparse
import datetime

import registros

BODY_TEMPLATES = {
    "decision": (
        "- {person} decidió: \n"
        "- porqué: \n"
        "- Claude eligió (sin aprobar): \n"
        "- descartado: \n"
        "- dónde vive: \n"
    ),
    "pregunta": "Qué hay que decidir, qué se sabe ya y qué bloquea.\n",
    "tarea": "- hecho cuando: \n- bloqueada por: \n",
}
SESSION_TEMPLATE = (
    "---\ntipo: sesion\nfecha: {date}\nautor: {author}\n---\n# {date} · {author}\n\n"
    "## Cambió\n\n## Probado\n\n## Sin probar\n\n## Lecciones\n\n## Siguiente\n"
)


def create_record(kind, title, group, author, author_letter, date):
    identifier = registros.next_identifier(kind, author_letter)
    path = registros.VAULT_ROOT / kind.directory / f"{identifier}-{registros.slugify(title)}.md"
    header = (
        f"---\ntipo: {kind.name}\nid: {identifier}\nfecha: {date}\nautor: {author}\n"
        f"estado: {kind.open_state}\n{kind.group_field}: {group}\n---\n# {identifier} · {title}\n"
    )
    path.write_text(header + BODY_TEMPLATES[kind.name].format(person=author.capitalize()), encoding="utf-8")
    return path


def create_session_note(author, date):
    path = registros.VAULT_ROOT / "bitacora" / f"{date}-{author}.md"
    if not path.exists():
        path.write_text(SESSION_TEMPLATE.format(date=date, author=author), encoding="utf-8")
    return path


def main():
    parser = argparse.ArgumentParser(description="Crea un registro nuevo con su ID y encabezado.")
    parser.add_argument("tipo", choices=[*registros.KINDS, "bitacora"])
    parser.add_argument("titulo", nargs="?", default="")
    parser.add_argument("--tema", "--grupo", dest="group", default="")
    parser.add_argument("--autor", default="")
    parser.add_argument("--fecha", default=datetime.date.today().isoformat())
    arguments = parser.parse_args()
    author, author_letter = registros.resolve_author(arguments.autor)
    if arguments.tipo == "bitacora":
        path = create_session_note(author, arguments.fecha)
    else:
        if not arguments.titulo or not arguments.group:
            parser.error("hacen falta el título y --tema (decisión) o --grupo (pregunta, tarea)")
        path = create_record(registros.KINDS[arguments.tipo], arguments.titulo, arguments.group, author, author_letter, arguments.fecha)
    print(path.relative_to(registros.VAULT_ROOT).as_posix())


if __name__ == "__main__":
    main()
