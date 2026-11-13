#!/usr/bin/env python3
import pathlib
import re
import sys

VAULT_ROOT = pathlib.Path(__file__).resolve().parent.parent
BODY_MARKER = "# huella"
CHECKSUM_SEED = 7
CHECKSUM_MODULUS = 4294967296
LINE_HASH_MODULUS = 16777216
PATCH_HEADER = re.compile(r"^@parche base=(\d+) nuevas=(\d+) suma=([0-9a-f]{8})$")
COPY_OPERATION = re.compile(r"^=(\d+)-(\d+)$")


def checksum(text):
    value = CHECKSUM_SEED
    for byte in text.encode("utf-8"):
        value = (value * 31 + byte) % CHECKSUM_MODULUS
    return value


def split_note(path):
    lines = path.read_text(encoding="utf-8").rstrip("\n").split("\n")
    marker_index = lines.index(BODY_MARKER)
    return lines[:marker_index], [line.rstrip() for line in lines[marker_index:]]


def print_base(path):
    _, body = split_note(path)
    print("".join("%06x" % (checksum(line) % LINE_HASH_MODULUS) for line in body))


def apply_patch(path):
    header, body = split_note(path)
    patch = sys.stdin.read().rstrip("\n").split("\n")
    declared = PATCH_HEADER.match(patch[0])
    if not declared:
        sys.exit("FALLA: la primera línea no es un encabezado @parche")
    base_count, new_count, expected_checksum = int(declared.group(1)), int(declared.group(2)), declared.group(3)
    if base_count != len(body):
        sys.exit(f"FALLA: el parche parte de {base_count} líneas y la nota tiene {len(body)}; pedir la base otra vez")
    rebuilt = []
    for operation in patch[1:]:
        copied = COPY_OPERATION.match(operation)
        if copied:
            rebuilt.extend(body[int(copied.group(1)) - 1:int(copied.group(2))])
        elif operation.startswith("+"):
            rebuilt.append(operation[1:])
        else:
            sys.exit(f"FALLA: operación desconocida: {operation[:40]}")
    actual_checksum = "%08x" % checksum("\n".join(rebuilt))
    if len(rebuilt) != new_count or actual_checksum != expected_checksum:
        sys.exit(f"FALLA: el resultado no coincide ({len(rebuilt)} líneas, suma {actual_checksum}); la nota no se tocó. Regenerar sin base")
    path.write_text("\n".join(header + rebuilt) + "\n", encoding="utf-8")
    print(f"OK {path.name}: {len(body)} → {len(rebuilt)} líneas, {sum(1 for operation in patch[1:] if operation.startswith('+'))} nuevas o cambiadas")


def main():
    if len(sys.argv) != 3 or sys.argv[1] not in ("base", "aplicar"):
        sys.exit("uso: parche.py base <nota> | parche.py aplicar <nota> < parche")
    path = VAULT_ROOT / sys.argv[2]
    if sys.argv[1] == "base":
        print_base(path)
    else:
        apply_patch(path)


if __name__ == "__main__":
    main()
