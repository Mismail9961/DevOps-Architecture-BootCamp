# Python Data Types — Lecture Notes

Combined notes from a two-part lecture covering Python's core data types, their behavior, and practical relevance.

## Overview

Python organizes data into **eight main categories** across roughly 15 built-in classes:

- Numeric
- Sequence
- Mapping
- Set
- Boolean
- Binary
- None
- Custom (class-based)

---

## Part 1 — Numeric & Sequence Types

### Numeric Types
- **Integers, floats, complex numbers** (e.g., `1 + 2j`)
- Complex numbers are rare in everyday code but important in scientific/engineering domains (signal processing, circuits)
- Can come up in interviews to test depth of knowledge

### Sequences
| Type | Mutable? | Notes |
|------|----------|-------|
| List | ✅ Yes | Supports `.append()`, `.clear()`, etc. |
| Tuple | ❌ No | Fixed, safe for constant data |
| String | ❌ No | Sequence of characters, treated distinctly from lists/tuples |

---

## Part 2 — Mappings, Sets & Binary Types

### Dictionaries (Mapping Type)
- Stores data as **key-value pairs** instead of positional data
- Ideal for structured, self-describing data
- Example: a class record with `date`, `time`, `attendance`, `location`

### Sets
| Type | Mutable? | Notes |
|------|----------|-------|
| Set | ✅ Yes | Unique, unordered elements; supports add/remove |
| Frozen Set | ❌ No | Immutable version; good for fixed collections |

Use case: managing unique roles like `admin`, `trainer`, `student`.

### Syntax Cheat Sheet
- `[]` → List
- `()` → Tuple
- `{}` → Dictionary / Set

### Binary Types
- **Bytes / Byte Arrays** — raw binary data for file transfer, encryption, network packets
- **Memory Views** — access large binary data without copying it, improving performance

---

## Key Takeaways

1. **Mutable vs. Immutable** is the recurring theme across almost every type (lists/tuples, sets/frozen sets, strings) — it directly affects performance and safety in real code.
2. **Practical over rote learning** — the instructor emphasizes hands-on understanding over memorization, tied to real use cases like DevOps scripting and scientific computing.
3. **Interview relevance** — type distinctions (especially mutability and complex numbers) are common interview topics.
4. **Custom types** — once you understand that built-ins are themselves classes, you can build your own data types via classes.

---

*Notes compiled from a two-part Python data types lecture.*