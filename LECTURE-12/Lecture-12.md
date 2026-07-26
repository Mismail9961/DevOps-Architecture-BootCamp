# Python Basics — Session Notes

## Overview

This session covered foundational Python programming concepts, including variables and data types, working with dates and times, number rounding, and list iteration. It closed with course administration details: weekly quizzes, assignments, and attendance tracking.

## Topics Covered

### 1. Variables and Data Types

Python treats data types as classes (`str`, `int`, `float`, `bool`). The built-in `type()` function is used to inspect a variable's type.

Example variables:

```python
course_name = "DevOps TDS"     # string
class_duration = 120           # integer
class_length = 75.0            # float
class_active = True            # boolean

print(type(course_name))
```

### 2. Working with Dates and Times

Python does not handle dates natively — the `datetime` module must be imported.

```python
from datetime import date, datetime

start_date = datetime.date(2026, 3, 24)
today = datetime.date.today()

# Difference between two dates
delta = today - start_date
print(delta.days)

# Formatting output
print(today.strftime("%d-%m-%Y"))
```

Key points:
- Converting minutes to hours requires explicit type casting (`int()` or `float()`).
- Concatenating a `datetime` object with a string requires converting it first with `str()`.

### 3. Rounding Numbers

The `math` module provides different rounding behaviors:

```python
import math

math.ceil(4.2)   # rounds up -> 5
math.floor(4.8)  # rounds down -> 4
round(4.5)       # rounds to nearest
7 // 2           # integer division, removes decimal
```

Use `round()` for nearest-value rounding, `math.ceil()` to always round up, and `math.floor()` to always round down.

### 4. Lists (Arrays) and Iteration

Lists store ordered collections of items, such as weekly class topics. The `enumerate()` function provides both the index and the value while looping, and its start index can be shifted from the default of 0.

```python
class_topics = ["Variables", "Dates", "Rounding", "Lists"]

for index, topic in enumerate(class_topics, start=1):
    print(f"Week {index}: {topic}")
```

### 5. Python vs. Bash / JQ

Python was presented as a simpler, more capable alternative to Bash scripting and JQ for tasks like JSON manipulation, largely due to its readability and extensive library ecosystem.

## Course Administration

- Weekly quizzes and lab assignments will be used to track learning outcomes.
- Attendance is tied to assessments and course continuation.
- The curriculum intentionally starts with core Python fundamentals before moving into web development or backend topics, matching the class's current skill level.

## Summary

This session built a foundation in Python syntax and standard library usage (data types, `datetime`, `math`, lists) while also establishing the structure — quizzes, labs, attendance — that the rest of the course will follow.