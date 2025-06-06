#!/bin/bash

# === Project root ===
mkdir -p .windsurf/rules
mkdir -p .windsurf/workflows
mkdir -p docs
mkdir -p src/app
mkdir -p src/screens
mkdir -p src/widgets
mkdir -p src/models
mkdir -p src/services
mkdir -p src/providers
mkdir -p src/utils
mkdir -p test

# === Placeholder files ===
touch .windsurf/rules/flutter.yaml
touch .windsurf/workflows/default.workflow.yaml
touch docs/ARCHITECTURE.md
touch docs/TASK.md
touch src/main.dart
touch pubspec.yaml
touch analysis_options.yaml
touch README.md

echo "✅ Flutter project structure initialized."
