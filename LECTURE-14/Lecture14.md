# Python Programming Essentials

A structured reference covering built-in functions, conditionals, loops, the modern `match-case` statement, and regular expressions (regex) in Python.

---

## Table of Contents

1. [Working with Lists & Built-in Functions](#1-working-with-lists--built-in-functions)
2. [Conditional Statements (`if` / `elif` / `else`)](#2-conditional-statements-if--elif--else)
3. [Loops](#3-loops)
4. [The `match-case` Statement (Python 3.10+)](#4-the-match-case-statement-python-310)
5. [Regular Expressions (`re` module)](#5-regular-expressions-re-module)
6. [Best Practices](#6-best-practices)
7. [What's Next](#7-whats-next)

---

## 1. Working with Lists & Built-in Functions

Python provides several built-in functions for quickly analyzing and transforming list data.

| Function | Definition |
|---|---|
| `min(list)` | Returns the smallest value in an iterable. |
| `max(list)` | Returns the largest value in an iterable. |
| `sum(list)` | Returns the total of all numeric values in an iterable. |
| `sorted(list)` | Returns a **new** list with elements arranged in ascending order, leaving the original list unchanged. |
| `sorted(list, reverse=True)` | Returns a new list sorted in **descending** order. |
| `reversed(list)` | Returns an iterator that yields the list's elements in reverse order (often wrapped in `list()` or `sorted()`). |

### Example

```python
ages = [23, 19, 34, 27, 19]

print(min(ages))                     # 19
print(max(ages))                     # 34
print(sum(ages))                     # 122
print(sorted(ages))                  # [19, 19, 23, 27, 34]
print(sorted(ages, reverse=True))    # [34, 27, 23, 19, 19]
print(list(reversed(sorted(ages))))  # [34, 27, 23, 19, 19]
```

**Key takeaway:** Combining `sorted()` with `reverse=True`, or nesting it inside `reversed()`, gives flexible control over ascending/descending order without mutating the original list.

---

## 2. Conditional Statements (`if` / `elif` / `else`)

Conditionals let a program branch its behavior based on whether an expression evaluates to `True` or `False`.

- **`if`** — runs a block only if its condition is `True`.
- **`elif`** ("else if") — checked only if the preceding `if`/`elif` was `False`; allows multiple mutually exclusive conditions.
- **`else`** — a fallback block that runs if none of the above conditions were `True`.

### Example: Password Length Validation

```python
password = input("Enter your password: ")

if len(password) > 8:
    print("Strong password length.")
elif len(password) == 8:
    print("Acceptable password length.")
else:
    print("Password is too short.")
```

**Use case:** Input validation — confirming that user-provided data (like a password) meets a required condition before accepting it.

---

## 3. Loops

### 3.1 `for` Loops

A `for` loop iterates over a sequence (list, string, range, etc.), executing a block of code once per item.

**Looping over a `range()`:**
```python
for i in range(5):
    print(i)   # 0, 1, 2, 3, 4
```

**Looping directly over a list:**
```python
students = ["Ali", "Sara", "Zain"]
for student in students:
    print(student)
```

### 3.2 `enumerate()`

`enumerate()` wraps an iterable and returns pairs of `(index, value)`, letting you track position and content simultaneously — useful for tagging or indexed processing.

```python
students = ["Ali", "Sara", "Zain"]

for index, student in enumerate(students):
    print(f"{index}: {student}")

# Output:
# 0: Ali
# 1: Sara
# 2: Zain
```

**Key distinction:** `range()` produces plain index numbers, while direct list iteration gives you the values themselves — `enumerate()` bridges both by providing them together.

---

## 4. The `match-case` Statement (Python 3.10+)

`match-case` is Python's structural pattern-matching statement, introduced in **Python 3.10**. It offers a cleaner, more readable alternative to long `if-elif` chains or dictionary-based lookups when handling multiple discrete conditions.

### Syntax

```python
status_code = 404

match status_code:
    case 200:
        print("OK")
    case 404:
        print("Not Found")
    case 500:
        print("Internal Server Error")
    case _:
        print("Unknown status code")
```

- Each `case` represents one possible pattern to match against.
- The underscore `_` acts as a **wildcard/default case**, catching any value not matched above (similar to `else`).

### Comparison

| Approach | Readability | Best For |
|---|---|---|
| `if-elif-else` | Verbose for many conditions | Small number of conditions, complex boolean logic |
| Dictionary mapping | Compact, but less explicit | Simple key → value lookups |
| `match-case` | Clean, structured, explicit | Multiple discrete values/patterns (e.g., status codes, commands) |

---

## 5. Regular Expressions (`re` module)

Regular expressions (regex) are patterns used to search, match, extract, and manipulate text. Python's built-in `re` module provides this functionality.

### 5.1 Core Functions

| Function | Definition |
|---|---|
| `re.match(pattern, string)` | Checks for a match **only at the beginning** of the string. |
| `re.findall(pattern, string)` | Returns a list of **all** non-overlapping matches in the string. |
| `re.sub(pattern, replacement, string)` | Replaces all matches of the pattern with the replacement text. |
| `re.split(pattern, string)` | Splits the string into a list wherever the pattern matches. |

### 5.2 Example: Substitution

```python
import re

text = "Error 404: Page not found. Error 404 occurred again."
result = re.sub(r"404", "Not Found", text)
print(result)
# Error Not Found: Page not found. Error Not Found occurred again.
```

### 5.3 Anchors and Character Classes

- **`^`** — anchors the pattern to the **start** of the string.
- **`$`** — anchors the pattern to the **end** of the string.
- **`+`** — matches one or more repetitions of the preceding character/group.
- **`[...]`** — defines a character class (a set of allowed characters).

### 5.4 Example: Email Validation

```python
import re

email_pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

test_emails = ["user@example.com", "invalid-email", "name.surname@domain.co"]

for email in test_emails:
    if re.match(email_pattern, email):
        print(f"{email} is valid")
    else:
        print(f"{email} is invalid")
```

**Breakdown:**
- `^[a-zA-Z0-9._%+-]+` — one or more allowed characters at the start (the username part).
- `@` — a literal "@" separating username and domain.
- `[a-zA-Z0-9.-]+` — the domain name.
- `\.[a-zA-Z]{2,}$` — a literal dot followed by at least two letters (the TLD), anchored to the end.

### 5.5 Example: IP Address Validation

```python
import re

ip_pattern = r"^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$"

test_ips = ["192.168.1.1", "999.999.999.999", "not.an.ip"]

for ip in test_ips:
    if re.match(ip_pattern, ip):
        print(f"{ip} matches the IP format")
    else:
        print(f"{ip} does not match")
```

**Breakdown:** Four groups of `1–3` digits (`\d{1,3}`) separated by literal dots, anchored with `^` and `$` to ensure the entire string conforms to the format (note: this basic pattern checks *format* only, not that each number is ≤ 255).

---

## 6. Best Practices

- ✅ **Import modules at the top of the file** (e.g., `import re`) rather than inline within functions — improves readability and avoids repeated imports.
- ✅ **Always anchor regex patterns** with `^` and `$` when you need to validate an *entire* string, not just find a substring match somewhere within it.
- ✅ Prefer `match-case` over long `if-elif` chains when checking a variable against several discrete, known values.
- ✅ Use `enumerate()` instead of manually tracking an index counter when you need both position and value in a loop.

---

## 7. What's Next

Planned/upcoming topics for follow-up sessions:

- Defining and using **functions**
- Making **API calls** in Python
- Working with file formats: **YAML** and **Markdown**

---

*This README summarizes core Python fundamentals: list operations, conditionals, loops, `match-case`, and regex — intended as a quick-reference guide for beginner-to-intermediate learners.*