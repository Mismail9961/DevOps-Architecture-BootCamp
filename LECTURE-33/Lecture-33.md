# Lecture 33: FastAPI Calculator with Jinja2 + GitHub

## 1. What We Built

A simple **calculator web app** in Python:

- **FastAPI** = backend (handles requests)
- **Jinja2** = templates (returns full HTML pages, not just JSON)
- **JSON file** = tiny database that stores calculation history
- Runs locally at `localhost:8000`

## 2. How the App Works

- Supports **add, subtract, multiply, divide** (division checks for zero).
- The user submits two numbers and an operation through a form.
- The result is saved to a JSON file as history.
- `templates/index.html` loops through the history (newest first) and shows it.

### Inputs (with type hints)

| Field | Type |
|---|---|
| First number | `float` |
| Second number | `float` |
| Operation | `str` |

Type hints give automatic validation and cleaner code.

## 3. Key Concepts

### FastAPI + Jinja2
- Jinja2 lets FastAPI return **rendered HTML** using `Request` and `HTMLResponse`.
- Good for multi-page apps, not just APIs for SPAs.
- Templates must live in a `templates/` folder.

### JSON File as a Database
- Check if the file exists, then `json.load` to read and `json.dump` to write.
- Fine for prototypes and small apps, but it doesn't scale.

### Modern FastAPI Style
- Use typed parameters and explicit imports instead of older-style endpoint definitions.
- Endpoints are `async`.

## 4. Bugs We Hit and Fixes

| Error | Cause | Fix |
|---|---|---|
| JSON decode error | Wrong data being saved or loaded | Check file contents and data types |
| `unhashable type` | Passed a **dict** to the template instead of a **list** | Convert to a list, then reverse it |
| POST type mismatch | Numbers received as the wrong type | Use `float` for numbers, `str` for operation |

**Lesson:** the data structure you send must match what the template expects.

## 5. Dependencies: `requirements.txt`

List packages in a file instead of installing them one by one:

```text
fastapi
jinja2
uvicorn
```

Install everything with:

```bash
pip install -r requirements.txt
```

This keeps environments reproducible for teammates and CI/CD.

## 6. Git & GitHub Workflow

```bash
git init                                  # start a repo
git add .                                 # stage all files
git commit -m "Initial commit"            # save a snapshot
git branch -M main                        # rename branch to main
git remote add origin <repo-url>          # link to GitHub
git push -u origin main                   # upload code
```

### `.gitignore`
Add files you don't want in the repo, like Python cache:

```text
__pycache__/
*.pyc
```

## 7. Takeaways

1. FastAPI + Jinja2 = a full-stack Python app.
2. A JSON file is a quick, simple database for prototypes.
3. Most bugs come from **wrong data types**, so read the terminal errors.
4. Always use `requirements.txt`.
5. Use Git early, with clear commit messages, and push to GitHub.
6. AI (like ChatGPT) speeds up the first draft, but you must understand and debug the code yourself.
7. Practice matters more than theory.

## Quick Summary

Prompt AI for a starter, build with FastAPI + Jinja2, store history in JSON, fix type errors, list dependencies in `requirements.txt`, then `git init` → commit → push to GitHub.