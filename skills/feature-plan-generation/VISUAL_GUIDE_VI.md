# Feature Plan Generation Skill - Visual Guide

## 🎬 Skill Workflow - Các Bước Chi Tiết

```
┌─────────────────────────────────────────────────────────────────┐
│                  FEATURE PLAN GENERATION SKILL                  │
│                                                                   │
│  INPUT:                                                          │
│  ┌─────────────────────┐    ┌──────────────────────┐            │
│  │ Feature Spec File   │    │ Project Patterns File│            │
│  │ (requirements,      │    │ (tech stack,         │            │
│  │  acceptance crit,   │    │  conventions,        │            │
│  │  constraints)       │    │  architecture)       │            │
│  └──────────┬──────────┘    └──────────┬───────────┘            │
│             │                          │                        │
│             └──────────┬───────────────┘                        │
│                        ↓                                        │
│            ┌────────────────────────┐                          │
│            │  GENERATE-PLAN.SH      │                          │
│            │  (Bash Script)         │                          │
│            │                        │                          │
│            │ 1. Validate files      │                          │
│            │ 2. Parse content       │                          │
│            │ 3. Generate tasks      │                          │
│            │ 4. Create document     │                          │
│            └────────────┬───────────┘                          │
│                        ↓                                        │
│  OUTPUT:                                                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ implementation-plan.md (Markdown)                       │  │
│  │                                                           │  │
│  │ ├─ Overview                                             │  │
│  │ ├─ Architecture Decisions                              │  │
│  │ ├─ Phase 1: Foundation & Setup      ← 2 tasks          │  │
│  │ │  ├─ Task 1.1: Analyze & Plan                         │  │
│  │ │  ├─ Task 1.2: Setup & Config                         │  │
│  │ │  └─ Checkpoint                                        │  │
│  │ ├─ Phase 2: Core Implementation     ← 2 tasks          │  │
│  │ │  ├─ Task 2.1: Core Feature                           │  │
│  │ │  ├─ Task 2.2: Integration                            │  │
│  │ │  └─ Checkpoint                                        │  │
│  │ ├─ Phase 3: Refinement & Polish     ← 3 tasks          │  │
│  │ │  ├─ Task 3.1: Error Handling                         │  │
│  │ │  ├─ Task 3.2: Testing & Coverage                     │  │
│  │ │  ├─ Task 3.3: Code Quality                           │  │
│  │ │  └─ Checkpoint                                        │  │
│  │ ├─ Parallelization Opportunities                       │  │
│  │ ├─ Risks & Mitigations                                 │  │
│  │ ├─ Success Criteria                                    │  │
│  │ └─ Open Questions                                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                   │
│  + JSON Output (status, stats, summary)                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Task Structure - Mỗi Task Có Gì?

```
┌──────────────────────────────────────┐
│ Task 1.1: Analyze and Plan           │
├──────────────────────────────────────┤
│                                       │
│ 📝 Description                        │
│    Review feature specs + patterns    │
│    Create technical plan              │
│                                       │
│ ✅ Acceptance Criteria                │
│    □ All requirements understood      │
│    □ Approach aligns with patterns    │
│    □ Dependencies identified          │
│                                       │
│ 🔍 Verification                       │
│    □ Manual review: Plan approved     │
│    □ Coverage: All criteria addressed │
│                                       │
│ 📁 Files Likely Touched               │
│    - Implementation plan document     │
│                                       │
│ 🔗 Dependencies                       │
│    None (first task!)                 │
│                                       │
│ 📏 Estimated Scope                    │
│    SMALL (1-2 files)                  │
│                                       │
└──────────────────────────────────────┘
```

---

## 🔄 Task Flow với Dependencies

```
PHASE 1: FOUNDATION & SETUP
┌────────────────┐
│  1.1: Analyze  │
│  & Plan        │
└────────┬───────┘
         │
         ↓
┌────────────────┐
│  1.2: Setup &  │
│  Config        │
└────────┬───────┘
         │
         ↓
    ✅ CHECKPOINT
    Foundation OK?
         │
    ─────┴─────
    YES      NO
    │        └─→ Fix & Retry
    ↓
PHASE 2: CORE IMPLEMENTATION
┌────────────────┐
│  2.1: Core     │
│  Feature       │
└────────┬───────┘
         │
         ↓
┌────────────────┐
│  2.2:          │
│  Integration   │
└────────┬───────┘
         │
         ↓
    ✅ CHECKPOINT
    Core OK?
         │
    ─────┴─────
    YES      NO
    │        └─→ Fix & Retry
    ↓
PHASE 3: REFINEMENT & POLISH
┌────────────────┐
│  3.1: Error    │
│  Handling      │
└────────┬───────┘
         │
         ↓
┌────────────────┐
│  3.2: Testing  │
│  & Coverage    │
└────────┬───────┘
         │
         ↓
┌────────────────┐
│  3.3: Code     │
│  Quality       │
└────────┬───────┘
         │
         ↓
    ✅ CHECKPOINT
    Complete OK?
         │
    ─────┴─────
    YES      NO
    │        └─→ Fix & Retry
    ↓
🎉 READY FOR PRODUCTION
```

---

## 📋 Phase 1: Foundation & Setup Chi Tiết

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: FOUNDATION & SETUP - Chuẩn Bị Cơ Sở Hạ Tầng       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Task 1.1: Analyze and Plan                                 │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Review all requirements from feature spec            │ │
│  │ • Review project patterns & conventions                │ │
│  │ • Design technical approach                            │ │
│  │ • Identify components & dependencies                   │ │
│  │                                                         │ │
│  │ Scope: SMALL (doc work, no code)                       │ │
│  │ Duration: ~30-60 min                                   │ │
│  │ Output: Technical plan document                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  Task 1.2: Setup & Configuration                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Create/update project config files                  │ │
│  │ • Setup environment variables                          │ │
│  │ • Initialize database schema if needed                 │ │
│  │ • Setup dev environment & dependencies                 │ │
│  │ • Verify build works                                   │ │
│  │                                                         │ │
│  │ Scope: SMALL (5-10% of total files)                    │ │
│  │ Duration: ~30-60 min                                   │ │
│  │ Output: Ready dev environment + passing build          │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  ✅ CHECKPOINT: Foundation                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ ✓ Project builds successfully                          │ │
│  │ ✓ Configuration verified                               │ │
│  │ ✓ Dev environment ready                                │ │
│  │ ✓ All basics in place                                  │ │
│  │                                                         │ │
│  │ Decision: Ready for Phase 2?                           │ │
│  │ If NO: Fix issues in Phase 1 tasks                     │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Phase 2: Core Implementation Chi Tiết

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: CORE IMPLEMENTATION - Triển Khai Tính Năng Chính   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Task 2.1: Core Feature Implementation                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Implement core business logic                        │ │
│  │ • Create data models/entities                          │ │
│  │ • Build services/controllers                           │ │
│  │ • Write core logic following patterns                  │ │
│  │ • Create unit tests for business logic                 │ │
│  │                                                         │ │
│  │ Scope: MEDIUM to LARGE (40-50% of files)               │ │
│  │ Duration: ~4-8 hours                                   │ │
│  │ Output: Working feature (can be tested)                │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  Task 2.2: Integration & Connections                        │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Connect to database                                  │ │
│  │ • Integrate with external services (API, email, etc)   │ │
│  │ • Connect to frontend/UI                               │ │
│  │ • Add to routing/navigation                            │ │
│  │ • Write integration tests                              │ │
│  │                                                         │ │
│  │ Scope: MEDIUM (20-30% of files)                        │ │
│  │ Duration: ~2-4 hours                                   │ │
│  │ Output: Fully integrated feature                       │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  ✅ CHECKPOINT: Core Features                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ ✓ Core logic works as specified                        │ │
│  │ ✓ Feature integrated with existing systems             │ │
│  │ ✓ End-to-end flow works (user can use it)             │ │
│  │ ✓ No breaking changes to existing features             │ │
│  │                                                         │ │
│  │ Decision: Feature working? Ready for Phase 3?          │ │
│  │ If NO: Fix integration issues in Phase 2 tasks         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## ✨ Phase 3: Refinement & Polish Chi Tiết

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: REFINEMENT & POLISH - Hoàn Thiện & Tối Ưu         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Task 3.1: Error Handling & Edge Cases                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Add error handling for all flows                      │ │
│  │ • Handle edge cases & invalid inputs                    │ │
│  │ • User-friendly error messages                          │ │
│  │ • Test error scenarios                                  │ │
│  │                                                         │ │
│  │ Scope: MEDIUM (10-15% of files)                        │ │
│  │ Duration: ~2-3 hours                                   │ │
│  │ Output: Robust error handling                          │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  Task 3.2: Testing & Coverage                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Write tests for all scenarios                         │ │
│  │ • Achieve >80% code coverage                            │ │
│  │ • Integration tests                                     │ │
│  │ • E2E tests for user flows                              │ │
│  │                                                         │ │
│  │ Scope: MEDIUM (15-20% of files)                        │ │
│  │ Duration: ~3-4 hours                                   │ │
│  │ Output: Comprehensive test suite                       │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  Task 3.3: Code Quality & Documentation                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ • Add JSDoc/TypeScript documentation                    │ │
│  │ • Follow code conventions & style guide                 │ │
│  │ • Run linter (ESLint) - fix issues                      │ │
│  │ • Create/update README and API docs                     │ │
│  │                                                         │ │
│  │ Scope: SMALL to MEDIUM (5-10% of files)                │ │
│  │ Duration: ~1-2 hours                                   │ │
│  │ Output: Clean, documented, production-ready code       │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                   │
│  ✅ CHECKPOINT: Complete & Ready for Review                 │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ ✓ All tests pass                                        │ │
│  │ ✓ Coverage >80%                                         │ │
│  │ ✓ Code quality verified (linting clean)                 │ │
│  │ ✓ Documentation complete                                │ │
│  │ ✓ No breaking changes                                   │ │
│  │                                                         │ │
│  │ 🎉 Feature ready for production!                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Ví Dụ Authentication Feature

```
┌─────────────────────────────────────────────┐
│ USER AUTHENTICATION FEATURE IMPLEMENTATION  │
└─────────────────────────────────────────────┘

PHASE 1: FOUNDATION & SETUP
├─ Task 1.1: Analyze & Plan
│  └─ Design: Registration → Verification → Login flow
│     Identify: User model, auth controller, email service
│
├─ Task 1.2: Setup & Config
│  └─ Create Prisma schema for User
│     Setup bcrypt, JWT
│     Create .env variables
│
└─ ✅ Checkpoint: Build succeeds, env ready

PHASE 2: CORE IMPLEMENTATION
├─ Task 2.1: Core Feature
│  ├─ UserService: register(), login(), verify()
│  ├─ AuthController: @Post(/register), @Post(/login)
│  ├─ Password hashing with bcrypt
│  ├─ JWT token generation
│  └─ Email verification logic
│
├─ Task 2.2: Integration
│  ├─ Connect UserService ↔ Database
│  ├─ Connect AuthController ↔ Email Service
│  ├─ Add routes to main app
│  ├─ Connect to frontend login form
│  └─ Add audit logging
│
└─ ✅ Checkpoint: Can register + login!

PHASE 3: REFINEMENT & POLISH
├─ Task 3.1: Error Handling
│  ├─ Validate email format
│  ├─ Check password strength
│  ├─ Handle duplicate emails
│  ├─ Rate limit login attempts
│  └─ Handle email service failures
│
├─ Task 3.2: Testing
│  ├─ Unit tests: bcrypt, JWT, validators
│  ├─ Integration tests: API endpoints
│  ├─ E2E tests: Full registration → login flow
│  └─ Coverage: >80%
│
├─ Task 3.3: Code Quality
│  ├─ Add JSDoc comments
│  ├─ TypeScript strict mode
│  ├─ Run ESLint, fix issues
│  └─ Update README with auth info
│
└─ ✅ Checkpoint: Production ready!
```

---

## 📈 Timelines

```
PHASE 1: ~1-2 hours
  Task 1.1: ~30-60 min (analysis)
  Task 1.2: ~30-60 min (setup)
  Checkpoint: ~15 min

PHASE 2: ~6-12 hours
  Task 2.1: ~4-8 hours (core logic)
  Task 2.2: ~2-4 hours (integration)
  Checkpoint: ~30 min

PHASE 3: ~6-9 hours
  Task 3.1: ~2-3 hours (error handling)
  Task 3.2: ~3-4 hours (testing)
  Task 3.3: ~1-2 hours (quality)
  Checkpoint: ~30 min

TOTAL: ~13-23 hours (depending on feature complexity)
```

---

## 🎓 Học Cách Sử Dụng

```
Step 1: Understand the workflow
  ├─ Read this file (you did it!)
  ├─ See the diagrams
  └─ Understand 3 phases

Step 2: See example output
  ├─ Review generated plan
  ├─ See task details
  ├─ Understand checkpoints
  └─ Note dependencies

Step 3: Use in your project
  ├─ Create feature spec
  ├─ Create project patterns
  ├─ Run skill
  ├─ Review generated plan
  ├─ Implement phase by phase
  ├─ Check off tasks
  └─ Hit checkpoints before moving on

Step 4: Success!
  └─ Feature complete!
```

---

**Bây giờ bạn hiểu skill hoạt động và các phase rồi! 🚀**
