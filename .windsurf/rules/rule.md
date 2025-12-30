---
trigger: manual

---
PROJECT CONTEXT

This repository contains a Flutter classified marketplace app (Divar-like).

UI is fully designed and finalized using Google Stitch

Current focus: clean architecture, structure, and controlled feature expansion

Backend is NOT implemented yet

AI agents are expected to work on this project safely and predictably

The documentation files in /docs are the single source of truth:

README.md

structure.md

roles.md

rules.md

todo.md

ai_workflow.md

GLOBAL AI BEHAVIOR RULES (MANDATORY)

Before writing or modifying any code, you MUST:

Read and follow all documentation in /docs

Identify the correct feature or folder

Reuse existing widgets and patterns

Apply the smallest possible change

Preserve UI and architecture integrity

If requirements are unclear → ASK FIRST

🚫 ABSOLUTE PROHIBITIONS

You MUST NOT:

❌ Redesign or visually change any existing UI

❌ Modify layout, spacing, typography, or colors unless explicitly instructed

❌ Move, rename, or delete files without permission

❌ Introduce backend logic, APIs, Firebase, or networking unless requested

❌ Hardcode colors, text styles, paddings, or text

❌ Add business logic inside UI widgets

❌ Use Navigator.push directly inside widgets

❌ Bypass GoRouter or clean architecture rules

Violating these rules is considered a failure.

✅ REQUIRED ENGINEERING PRACTICES

You MUST:

Use Flutter (latest stable)

Follow feature-based clean architecture

Keep UI code inside presentation/

Keep mock data inside data/

Use shared widgets from core/widgets/

Use theme, constants, and reusable components

Keep widgets stateless by default

Write clean, readable, maintainable Dart code

📁 STRUCTURE ENFORCEMENT

Each feature owns its own screens and widgets

Screens must NOT import other screens directly

All routes must be defined in routes/app_router.dart

Models must remain reusable and UI-agnostic

🧭 NAVIGATION RULES

Use GoRouter only

No inline navigation logic inside widgets

No anonymous routes

Navigation changes require explicit instruction

🤖 AI DECISION-MAKING RULE

When multiple implementation options exist:

Priority order:

UI consistency

Architectural cleanliness

Reusability

Simplicity

Performance (last)

Never optimize prematurely.

📤 OUTPUT RULES

When generating code:

Provide complete, valid Flutter files

Match existing naming conventions

Do not include explanations unless explicitly asked

Do not refactor unrelated code

Do not introduce new dependencies unless approved

🛑 FINAL SAFETY CLAUSE

If an instruction conflicts with:

/docs/rules.md

existing architecture

finalized UI

You MUST stop and ask for clarification.

SYSTEM ASSUMPTION (ALWAYS TRUE)

UI is final.
Architecture is sacred.
Stability > speed.
