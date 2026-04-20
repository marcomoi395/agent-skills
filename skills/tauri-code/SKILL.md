---
name: tauri-code
description: Guides agents through developing desktop applications using Tauri with a Svelte + TypeScript frontend. Use when building or modifying a Tauri app, adding IPC commands, integrating native APIs, or packaging for desktop platforms.
---

# Tauri Code (Svelte + TypeScript)

## Overview

Build desktop apps with Tauri while keeping a hard boundary between:

- UI code (Svelte + TypeScript)
- privileged/native code (Tauri commands + Rust)

This skill focuses on a safe, testable workflow: define the boundary, implement only what is needed, and verify with real desktop runs and packaging.

## When to Use

- You are creating or updating a Tauri desktop app using Svelte + TypeScript
- You need to add or change IPC commands (`invoke`/command handlers)
- You need native integrations (filesystem, dialogs, tray, notifications)
- You are seeing security/capability issues (allowlist/capabilities, blocked APIs)
- You are preparing builds for macOS/Windows/Linux

**When NOT to use:** Pure web apps (no `src-tauri/`), backend-only services, or changes that do not touch Tauri/Svelte/desktop packaging.

## The Workflow

1. **Identify the concrete target and constraints (no guessing)**

   Determine:
   - Tauri major version used by the repo (it changes config structure and API imports)
   - whether the UI is SvelteKit or Vite + Svelte
   - OS targets you must support (macOS/Windows/Linux)
   - what data crosses the boundary (UI -> command -> native)

   Verification:
   - [ ] You can point to `src-tauri/Cargo.toml` and the Tauri config file(s) used in this repo
   - [ ] You have a written list of inputs/outputs for each command you will add/change

2. **Design the boundary (UI vs native) before writing code**

   Rules:
   - UI never directly accesses privileged resources (filesystem, shell, process, etc.)
   - all privileged operations happen behind a small set of commands
   - commands accept validated, minimal inputs; return typed, minimal outputs

   Verification:
   - [ ] Every privileged operation you need maps to a command name
   - [ ] Each command has an explicit request/response shape (TypeScript type + Rust struct)

3. **Implement UI-side calls with typed wrappers (and centralized error handling)**

   Create a thin wrapper per command so UI code doesn't scatter `invoke` calls:

   ```ts
   // ui/src/lib/tauri/commands.ts
   export type ReadTextFileInput = { path: string };
   export type ReadTextFileOutput = { contents: string };

   // NOTE: import path differs between Tauri major versions.
   // Use the import the existing repo uses.
   import { invoke } from '@tauri-apps/api/tauri';

   export async function readTextFile(
     input: ReadTextFileInput
   ): Promise<ReadTextFileOutput> {
     return await invoke('read_text_file', input);
   }
   ```

   UI rules:
   - treat all command failures as expected (user cancels, file not found, permission denied)
   - surface actionable messages in UI; log structured details for debugging

   Verification:
   - [ ] No raw `invoke(...)` calls outside the wrapper module(s)
   - [ ] UI state handles loading, success, and failure states

4. **Implement command handlers with strict validation and least privilege**

   Command rules:
   - validate and normalize inputs at the boundary
   - do not accept arbitrary paths/URLs unless required by the product
   - do not expand capability/allowlist scope "just to make it work"

   If a native API call fails:
   - return a structured error (do not leak secrets or full file contents into error strings)
   - map errors into a stable error shape the UI can render

   Verification:
   - [ ] Inputs are validated (type + runtime checks) before use
   - [ ] Exposed commands are the minimum set needed

5. **Configure permissions/capabilities deliberately (and document why)**

   Update only the minimum required capabilities/allowlist entries for:
   - filesystem access
   - network access
   - shell/process APIs
   - dialogs/notifications/tray

   Verification:
   - [ ] The config changes are scoped to only the APIs you used
   - [ ] You can explain why each capability is needed

6. **Networking: prefer a single client boundary and consistent policies**

   If the app calls an external backend:
   - centralize HTTP calls in one module (not scattered across components)
   - use HTTPS; define timeouts; map errors into typed failures
   - do not rely on browser CORS mental models for a desktop runtime

   Verification:
   - [ ] Backend responses are validated (at least shape checks) before use
   - [ ] Retry is only used where idempotency is guaranteed

7. **Testing: prove behavior at the right level**

   Use the `test-driven-development` skill for logic changes. For desktop behaviors:
   - unit test pure functions and store logic
   - integration test command wrappers by mocking `invoke` at the boundary
   - keep a small set of manual smoke checks for native integrations

   Verification:
   - [ ] New logic has tests
   - [ ] Native integration has a manual smoke checklist item

8. **Build and package early (catch platform issues before the end)**

   For any change touching native APIs, permissions, or build config:
   - run a dev build and execute the flow inside the desktop shell
   - run a packaging build for at least one target platform as a gate

   Verification:
   - [ ] App runs in dev mode without console errors
   - [ ] Packaging completes successfully for at least one target

## Specific Techniques

### IPC Contract Pattern

- Define shared names for commands (string constants) to avoid typos.
- Keep request/response shapes small; prefer IDs over entire objects.
- Use one error envelope shape so UI rendering is consistent.

### UI State Pattern (Svelte)

- Represent async calls as `{ status: 'idle'|'loading'|'success'|'error', ... }`.
- Keep component logic small; push complex flows into stores or modules.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll just open up the allowlist/capabilities and tighten later" | You won't. Least privilege must be enforced at the moment you introduce the capability change. |
| "It's a desktop app, so input validation isn't that important" | Desktop apps still process untrusted input (files, URLs, clipboard, network). Validate at the boundary. |
| "I'll call `invoke` directly in this component; it's faster" | It creates untestable, duplicated error handling. Use a wrapper module so the boundary is controlled. |
| "I'll only test it manually" | Manual checks don't prevent regressions. Add tests for the logic and keep manual smoke checks for true native-only behavior. |

## Red Flags

- Adding broad filesystem/network/shell permissions without a specific requirement
- `invoke` calls scattered across UI components
- Command handlers that accept raw paths/URLs without constraints
- UI that has no error state (silent failures)
- Deferring packaging until the end (platform failures discovered too late)

## Verification

- [ ] Frontmatter includes `name` matching the directory name (`tauri-code`) and a clear `description`
- [ ] Each new/changed command has a typed UI wrapper and a defined request/response contract
- [ ] Capability/allowlist changes are minimal and justified
- [ ] Tests exist for new logic (see `test-driven-development`)
- [ ] Manual smoke checks cover native-only integrations
- [ ] App runs in dev mode and at least one packaging build succeeds

## See Also

- `test-driven-development` for test-first workflows on new logic and bug fixes
- `security-and-hardening` when adding capabilities, file access, auth, or handling untrusted inputs
