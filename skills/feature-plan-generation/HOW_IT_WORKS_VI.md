# Skill Feature Plan Generation - Giải Thích Chi Tiết

## 🎯 Skill Hoạt Động Như Thế Nào?

Skill này **tự động tạo kế hoạch triển khai** từ 2 input:

```
Input 1: Feature Spec          Input 2: Project Patterns
(requirements, acceptance      (tech stack, conventions,
 criteria, constraints)        architecture)
         ↓                               ↓
         └─────────────┬────────────────┘
                       ↓
          ┌────────────────────────┐
          │  generate-plan.sh      │
          │  (Bash Script)         │
          └────────────┬───────────┘
                       ↓
       Output: implementation-plan.md
       (3 phases, tasks, checkpoints, risks)
```

### Bước 1: Nhận Input
- Đọc feature specification file
- Đọc project patterns file
- Validate rằng file tồn tại

### Bước 2: Phân Tích
- Extract title từ feature spec
- Count sections và features
- Identify requirements

### Bước 3: Tạo Plan
- Load template cốt lõi
- Replace placeholders
- Generate plan document

### Bước 4: Output
- Tạo markdown file: `implementation-plan.md`
- Output JSON result (stats, status)
- Report thành công

---

## 📋 3 Phases Chi Tiết

Skill luôn tạo **3 phases** (giai đoạn) với **checkpoints** (điểm kiểm tra):

### **PHASE 1: Foundation & Setup** 🏗️

**Mục đích:** Chuẩn bị cơ sở hạ tầng, cấu hình, môi trường

**Tasks trong phase này:**

#### Task 1.1: Analyze and Plan
```
Mô tả: Review feature specs + project patterns
       Tạo technical plan chi tiết

Acceptance Criteria:
  ✓ All requirements understood & documented
  ✓ Technical approach aligns with patterns
  ✓ Dependencies identified

Verification:
  ✓ Manual review: Plan approved
  ✓ Coverage: All criteria addressed

Files touched: ~5-10% (mainly docs)
Scope: SMALL
Dependencies: None
```

#### Task 1.2: Setup & Configuration
```
Mô tả: Create/update project config files
       Setup dev environment

Acceptance Criteria:
  ✓ Config files created/updated
  ✓ Dev environment ready
  ✓ Build without errors

Verification:
  ✓ npm run build → success
  ✓ npm test → all pass
  ✓ No config errors

Files touched: ~5-10% (config files)
Scope: SMALL
Dependencies: Task 1.1
```

#### Checkpoint: Foundation ✅
```
Kiểm tra điểm dừng:
  ✓ Project builds successfully
  ✓ Configuration verified
  ✓ Decision: Proceed to Phase 2?
```

---

### **PHASE 2: Core Implementation** 💻

**Mục đích:** Triển khai tính năng chính, logic business

**Tasks trong phase này:**

#### Task 2.1: Core Feature Implementation
```
Mô tả: Implement primary feature
       Follow project patterns & specs

Acceptance Criteria:
  ✓ Core functionality works as specified
  ✓ Follows code conventions
  ✓ Tests cover main flows

Verification:
  ✓ npm test -- --grep "core-feature" → pass
  ✓ npm run build → success
  ✓ Manual functionality verification

Files touched: ~40-50% (main implementation)
Scope: MEDIUM to LARGE
Dependencies: Task 1.2
```

**Ví dụ (Authentication feature):**
- User registration logic
- Password hashing (bcrypt)
- Email verification flow
- Session token generation
- Login validation

#### Task 2.2: Integration & Connections
```
Mô tả: Connect feature to existing systems
       Ensure data flow end-to-end

Acceptance Criteria:
  ✓ Feature integrates with other systems
  ✓ Data flows correctly E2E
  ✓ No breaking changes

Verification:
  ✓ npm test -- --grep "integration" → pass
  ✓ npm run build → success
  ✓ E2E flow verification

Files touched: ~20-30% (API, DB, UI connections)
Scope: MEDIUM
Dependencies: Task 2.1
```

**Ví dụ (Authentication feature):**
- Connect to User database
- Integrate with Email service
- Connect to Session store (Redis)
- Add to API router
- Link to UI login form
- Audit logging integration

#### Checkpoint: Core Features ✅
```
Kiểm tra điểm dừng:
  ✓ All core tests pass
  ✓ Feature integrated with existing systems
  ✓ End-to-end flow works
  ✓ Decision: Proceed to Phase 3?
```

---

### **PHASE 3: Refinement & Polish** ✨

**Mục đích:** Tối ưu, test, tài liệu, error handling

**Tasks trong phase này:**

#### Task 3.1: Error Handling & Edge Cases
```
Mô tả: Add comprehensive error handling
       Handle edge cases gracefully

Acceptance Criteria:
  ✓ All error scenarios handled
  ✓ User-facing messages clear
  ✓ Edge cases covered by tests

Verification:
  ✓ npm test -- --grep "error|edge" → pass
  ✓ npm run build → success
  ✓ Manual error scenario testing

Files touched: ~10-15% (error handling)
Scope: MEDIUM
Dependencies: Task 2.2
```

**Ví dụ (Authentication feature):**
- Invalid email format
- Weak password
- Duplicate email registration
- Failed email delivery
- Session timeout
- Concurrent login attempts
- Rate limiting errors
- Database connection failures

#### Task 3.2: Testing & Coverage
```
Mô tả: Ensure >80% test coverage
       All acceptance criteria covered

Acceptance Criteria:
  ✓ Coverage >80%
  ✓ All acceptance criteria covered by tests
  ✓ No test failures

Verification:
  ✓ npm test → all pass
  ✓ npm run coverage → >80%
  ✓ npm run build → success

Files touched: ~15-20% (test files)
Scope: MEDIUM
Dependencies: Task 3.1
```

**Test Types:**
- Unit tests (services, utils)
- Integration tests (APIs)
- E2E tests (user flows)

#### Task 3.3: Code Quality & Documentation
```
Mô tả: Ensure code follows conventions
       Complete documentation

Acceptance Criteria:
  ✓ Code follows conventions
  ✓ All public functions documented
  ✓ No linting errors
  ✓ README/docs updated

Verification:
  ✓ npm run lint → pass (read-only)
  ✓ npm run build → success
  ✓ Manual code review
  ✓ Documentation complete

Files touched: ~5-10% (docs, lint fixes)
Scope: SMALL to MEDIUM
Dependencies: Task 3.2
```

**Ví dụ (Authentication feature):**
- JSDoc comments
- TypeScript types
- API documentation
- README updates
- Architecture decision record (ADR)
- Code style cleanup

#### Checkpoint: Complete & Ready for Review ✅
```
Kiểm tra điểm dừng - FINAL:
  ✓ All tests pass with >80% coverage
  ✓ Build succeeds without errors
  ✓ Linting clean (or exceptions documented)
  ✓ Code follows project conventions
  ✓ Documentation complete
  ✓ Ready for final review & integration
```

---

## 🔗 **Dependencies Giữa Các Tasks**

```
Task 1.1 (Analyze & Plan)
    ↓
Task 1.2 (Setup & Config)
    ↓
    ✅ CHECKPOINT: Foundation
    ↓
Task 2.1 (Core Feature)
    ↓
Task 2.2 (Integration)
    ↓
    ✅ CHECKPOINT: Core Features
    ↓
Task 3.1 (Error Handling)
    ↓
Task 3.2 (Testing)
    ↓
Task 3.3 (Code Quality)
    ↓
    ✅ CHECKPOINT: Complete
```

**Ghi chú:** Tasks có thể song song hóa nếu không có dependencies

---

## 💡 **Ví Dụ Thực Tế: Authentication Feature**

### Input 1: Feature Specification
```markdown
# User Authentication Feature

## Requirements
- User registration with email/password
- Email verification
- Login with session
- Password reset
- Session expiration (24h)

## Acceptance Criteria
- [ ] Registration works
- [ ] Verification email sent
- [ ] Login creates session
- [ ] Sessions expire after 24h
- [ ] Password reset works
```

### Input 2: Project Patterns
```markdown
# Project Patterns

## Tech Stack
- Backend: NestJS
- Database: PostgreSQL
- ORM: Prisma
- Testing: Jest

## Conventions
- DTOs for validation
- Services for business logic
- Controllers for HTTP
- bcrypt for passwords
```

### Generated Plan Output

```markdown
# Implementation Plan: User Authentication Feature

## Phase 1: Foundation & Setup

### Task 1.1: Analyze and Plan
- Review auth requirements vs patterns
- Design auth flow (registration → email verify → login)
- Identify: Prisma schema, DTOs, controllers needed

### Task 1.2: Setup & Configuration
- Create Prisma schema for User entity
- Add environment variables (.env)
- Setup bcrypt configuration
- Create test database

### Checkpoint: Foundation
- All requirements understood
- Schema designed
- Build succeeds

## Phase 2: Core Implementation

### Task 2.1: Core Feature Implementation
- Create User entity + migrations
- Build RegisterDTO, LoginDTO
- Create AuthService (register, login, verify)
- Create AuthController endpoints
- Implement bcrypt hashing

### Task 2.2: Integration & Connections
- Connect User API to database
- Add JWT token generation
- Integrate email service for verification
- Link to existing user endpoints

### Checkpoint: Core Features
- Registration works
- Verification emails sent
- Login creates sessions
- Integration complete

## Phase 3: Refinement & Polish

### Task 3.1: Error Handling & Edge Cases
- Handle duplicate emails
- Validate password strength
- Rate limit login attempts
- Handle email service failures

### Task 3.2: Testing & Coverage
- Unit tests for AuthService
- Integration tests for API endpoints
- E2E tests for full auth flow
- Target: >80% coverage

### Task 3.3: Code Quality & Documentation
- Add JSDoc comments
- Create API documentation
- Update README
- TypeScript strict mode

### Checkpoint: Complete
- All tests pass >80%
- No errors, fully integrated
- Ready for production
```

---

## 📊 **Output Statistics**

Khi skill chạy xong, nó output:

```json
{
  "status": "success",
  "plan_file": "implementation-plan.md",
  "stats": {
    "tasks_generated": 7,        ← 7 tasks
    "phases": 3,                  ← 3 phases
    "estimated_scope": "Medium"   ← Size estimate
  },
  "summary": {
    "overview": "Plan for authentication feature",
    "features_file": "auth-spec.md",
    "patterns_file": "PATTERNS.md",
    "ready_for_review": true
  }
}
```

---

## 🎯 **Quy Trình Hoàn Chỉnh**

```
1. User viết Feature Spec
   ↓
2. User viết/update Project Patterns
   ↓
3. Chạy feature-plan-generation skill
   ↓
4. Nhận: implementation-plan.md
   ↓
5. Review plan + adjust nếu cần
   ↓
6. Approve plan
   ↓
7. Implement từng task (Phase 1 → 2 → 3)
   ↓
8. Check Checkpoints giữa các phases
   ↓
9. Hoàn thành all tasks
   ↓
10. Feature sẵn sàng production
```

---

## ✨ **Tại Sao Cấu Trúc Này Tốt?**

### 1. **3 Phases = Logic Flow**
- **Phase 1:** Foundation - Cái gì cũng hoạt động trước
- **Phase 2:** Feature - Implement business logic
- **Phase 3:** Quality - Polish và test

### 2. **Checkpoints = Quality Gates**
- Verify phase trước khi tiếp tục
- Catch issues sớm
- Không rơi vào "chaotic implementation"

### 3. **Tasks = Implementable Units**
- Mỗi task có acceptance criteria rõ ràng
- Mỗi task có verification steps
- Mỗi task có scope estimate

### 4. **Dependencies = Clear Order**
- Biết task nào làm trước
- Dependencies explicit
- Tránh "blocked" situations

### 5. **Risks = Proactive**
- Identify risks trước
- Mitigation strategies
- Prioritize high-risk tasks sớm

---

## 🚀 **Sử Dụng Plan Để Implement**

Sau khi nhận plan, bạn:

1. **Review** mỗi task
2. **Implement** task theo order
3. **Test** acceptance criteria
4. **Check off** mỗi task
5. **At checkpoints** - verify cả phase
6. **Move to next phase** - nếu checkpoint pass

---

**Bây giờ bạn hiểu skill hoạt động như thế nào rồi!** 🎉

Có câu hỏi gì về các phase hoặc tasks không?
