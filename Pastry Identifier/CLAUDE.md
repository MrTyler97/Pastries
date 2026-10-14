# CLAUDE.md

## Directory restriction — read first

**Never access anything outside `/Users/vito/Pastry Identifier`, under any circumstances.**

- Do not read, search, list, write, edit, or delete any file or directory outside this folder.
- This includes the home directory, the Desktop, other projects, and the Pastries proxy source.
- Do not inspect running processes to discover other directories.
- Do not use any tool, shell command, script, or subagent to get around this.
- If a task seems to need something outside this folder, stop and ask the user to paste the relevant content instead.

## Project overview

**Pastries** is a SwiftUI iOS app for iOS 26+ that identifies pastries from a photo with an on-device CoreML model. For each result it shows the pastry's origin and history, finds nearby bakeries with MapKit, and shows nutrition data from a separate proxy server.

- `Pastry Identifier/Main Views/` holds the main screen (`ContentView`), the camera wrapper, and the results sheet (`SheetComponent`).
- `Pastry Identifier/Map/` holds the bakery search map and the selected-location sheet.
- `Pastry Identifier/Nutrition/` holds `NutritionService` (proxy call, error enum, label → food_id table) and `NutritionRowView` (the popover).
- `Pastry Identifier/Model/` holds the `Pastry_SelectorV6` classifier and the shared model types (`Objects.swift`).

## Conventions

- Keep code simple and easy to follow; this is a learning/testing project.
- Classification labels must exactly match the `pastries` names and the asset catalog image names.
- The project uses a synchronized folder group, so new files under `Pastry Identifier/` are compiled automatically.
- Default actor isolation is `MainActor` (Swift 5 mode, approachable concurrency).

## Secrets

- `Pastry Identifier/Nutrition/Secrets.swift` holds the proxy API key. It is gitignored and must never be committed or printed.
- The proxy runs at `http://localhost:3000` for Simulator testing.
