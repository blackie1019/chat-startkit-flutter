# 🏗 ARCHITECTURE.md

## 📌 Purpose

This file defines the high-level vision, architecture, and decisions for this Flutter project.  
It guides future contributors (humans + AI) with consistent context and reasoning.

> AI prompt:  
> **“Use the structure and decisions outlined in ARCHITECTURE.md.”**

---

## 🧱 Tech Stack

- **Framework**: Flutter (latest stable)
- **Language**: Dart
- **Architecture Pattern**: Clean Architecture (presentation / domain / data)
- **State Management**: BLoC
- **Routing**: `go_router`
- **Tests**: Unit, Widget, Integration (`flutter_test`, `mocktail`)

---

## 🧩 Structure Philosophy

All code lives in `/src`.  
- No global-level code outside `src/`
- Each feature folder can have its own `model`, `service`, and `screen` if needed

### Folder Contracts:
- `screens/`: Pure UI
- `services/`: Handles remote/local data
- `models/`: Typed definitions (DTOs, API types)
- `widgets/`: Reusable UI parts
- `providers/`: State logic
- `app/`: Route definitions, theme, bootstrapping

---

## 📐 Constraints

- All logic must be modular and testable
- Avoid tight coupling between screens and data sources
- Keep UI (screens) declarative and dumb
- Use composition over inheritance

---

## 🧠 AI Tool Roles

| Tool      | Role                                  |
|-----------|----------------------------------------|
| Windsurf  | Project scaffolding, auto-template generation |
| Roo Code  | Develop single feature/module at a time |
| Codex     | Refactor, clean up, suggest architecture evolution |

---
