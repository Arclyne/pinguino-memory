import dataclasses
import pathlib
import re
import unicodedata

VAULT_ROOT = pathlib.Path(__file__).resolve().parent.parent
AUTHORS_NOTE = VAULT_ROOT / "AUTORES.md"
LOCAL_AUTHOR_FILE = VAULT_ROOT / ".autor"
RECORD_ID = re.compile(r"^([DQT])-(\d+)([a-z]?)$")
AUTHOR_ROW = re.compile(r"^\| ([a-z0-9]+) \| ([a-z]) \|", re.MULTILINE)
SLUG_WORD_LIMIT = 6


@dataclasses.dataclass(frozen=True)
class Kind:
    name: str
    plural: str
    prefix: str
    directory: str
    digits: int
    group_field: str
    open_state: str


KINDS = {
    "decision": Kind("decision", "decisiones", "D", "decisiones", 3, "tema", "vigente"),
    "pregunta": Kind("pregunta", "preguntas", "Q", "pendientes/preguntas", 2, "grupo", "abierta"),
    "tarea": Kind("tarea", "tareas", "T", "pendientes/tareas", 2, "grupo", "pendiente"),
}
KINDS_BY_PLURAL = {kind.plural: kind for kind in KINDS.values()}


@dataclasses.dataclass
class Record:
    kind: Kind
    path: pathlib.Path
    fields: dict
    title: str
    text: str

    @property
    def identifier(self):
        return self.fields.get("id", "")

    @property
    def group(self):
        return self.fields.get(self.kind.group_field, "")

    @property
    def state(self):
        return self.fields.get("estado", "")

    @property
    def sort_key(self):
        match = RECORD_ID.match(self.identifier)
        return (int(match.group(2)), match.group(3)) if match else (0, self.identifier)

    @property
    def summary_line(self):
        return f"{self.identifier} | {self.group} | {self.state} | {self.title}"


def split_frontmatter(text):
    if not text.startswith("---\n"):
        return {}, text
    header, _, rest = text[4:].partition("\n---\n")
    fields = {}
    for line in header.splitlines():
        key, separator, value = line.partition(":")
        if separator:
            fields[key.strip()] = value.strip()
    return fields, rest


def record_title(body, identifier):
    for line in body.splitlines():
        if line.startswith("# "):
            return line[2:].replace(identifier + " · ", "", 1).strip()
    return ""


def load_records(kind):
    records = []
    for path in sorted((VAULT_ROOT / kind.directory).glob(kind.prefix + "-*.md")):
        text = path.read_text(encoding="utf-8")
        fields, body = split_frontmatter(text)
        records.append(Record(kind, path, fields, record_title(body, fields.get("id", "")), text))
    return sorted(records, key=lambda record: record.sort_key)


def slugify(title):
    plain = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode("ascii").lower()
    return "-".join(re.findall(r"[a-z0-9]+", plain)[:SLUG_WORD_LIMIT])


def author_letters():
    if not AUTHORS_NOTE.is_file():
        return {}
    return dict(AUTHOR_ROW.findall(AUTHORS_NOTE.read_text(encoding="utf-8")))


def resolve_author(explicit_author):
    letters = author_letters()
    author = explicit_author or (LOCAL_AUTHOR_FILE.read_text(encoding="utf-8").strip() if LOCAL_AUTHOR_FILE.is_file() else "")
    if author not in letters:
        known = ", ".join(sorted(letters)) or "ninguno"
        raise SystemExit(
            f"FALLA: no sé quién escribe (autor='{author}'). Pregunta a la persona quién es, "
            f"guarda su clave en el archivo .autor de la raíz del vault o pasa --autor. Claves en AUTORES.md: {known}"
        )
    return author, letters[author]


def next_identifier(kind, author_letter):
    highest = max((record.sort_key[0] for record in load_records(kind)), default=0)
    return f"{kind.prefix}-{highest + 1:0{kind.digits}d}{author_letter}"
