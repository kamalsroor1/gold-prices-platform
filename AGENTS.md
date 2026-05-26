# OpenCode Agent Instructions

- **Context:** Gold Prices Platform (Laravel Backend + Flutter).
- **Backend Pattern:** Strictly enforce Service-Repository pattern + DTOs as per `docs/06-backend/laravel-structure.md`.
- **Coding Standards:** Adhere to `docs/13-ai-rules/coding-standards.md` (SOLID/OOP/Patterns) before writing code.
- **Pricing Logic:** Centralize calculations via Service Layer. Refer `docs/04-pricing-engine/formulas.md`.
- **Deployment Constraint:** Optimized for Hostinger Shared Hosting. Use API caching (`docs/08-performance/performance-optimization.md`).
- **Workflow:** Always check `progress.json` and use `start-task.md` prompt for task initialization.
