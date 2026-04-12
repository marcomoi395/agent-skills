# Feature Plan Generation - Hướng Dẫn Chi Tiết

## Giới Thiệu

`feature-plan-generation` là một skill giúp tự động hóa quá trình tạo tài liệu kế hoạch triển khai dự án. Thay vì phải thực hiện phân tích thủ công, bạn chỉ cần chuẩn bị hai file markdown:

1. **Feature Specifications** - Mô tả chi tiết các yêu cầu tính năng
2. **Project Patterns** - Tài liệu về quy ước và pattern của dự án

Script sẽ tự động tạo ra một tài liệu plan hoàn chỉnh với các task, dependencies, và verification steps.

## Chuẩn Bị Đầu Vào

### Bước 1: Tạo Feature Specification File

Tạo một file markdown mô tả chi tiết tính năng cần triển khai.

**Cấu trúc tối thiểu:**

```markdown
# [Tên Tính Năng]

## Overview
Mô tả ngắn gọn về tính năng này là gì và tại sao cần nó.

## Feature Requirements
- Yêu cầu 1
- Yêu cầu 2
- Yêu cầu 3

## Acceptance Criteria
- [ ] Tiêu chí 1
- [ ] Tiêu chí 2
- [ ] Tiêu chí 3

## Technical Considerations
Các yêu cầu kỹ thuật, constraint, hoặc vấn đề cần xem xét.

## Integration Points
Các hệ thống/module khác mà tính năng này cần tích hợp với.
```

**Ví dụ đầy đủ:** Xem `examples/example-feature-spec.md`

### Bước 2: Tạo Project Patterns File

Tạo một file markdown mô tả các pattern, quy ước, và kiến trúc của dự án.

**Cấu trúc tối thiểu:**

```markdown
# Project Patterns & Conventions

## Technology Stack
- Frontend: ...
- Backend: ...
- Database: ...

## Project Structure
```
Mô tả cấu trúc thư mục
```

## Code Style & Conventions
- Naming conventions
- File naming
- Import organization

## Testing Strategy
- Unit tests
- Integration tests
- E2E tests

## API Conventions
- Endpoint formats
- Response formats
- Error handling

## Database Patterns
- Schema conventions
- Naming rules

## Git Conventions
- Commit message format
- Branch naming
```

**Ví dụ đầy đủ:** Xem `examples/example-project-patterns.md`

## Sử Dụng Skill

### Cách 1: OpenCode / Claude Code

```typescript
// Gọi skill từ agent
skill("feature-plan-generation")
```

Agent sẽ hướng dẫn bạn qua các bước.

### Cách 2: Terminal Command

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/auth-feature.md \
  --patterns ./PATTERNS.md \
  --output ./planning/auth-plan.md
```

**Arguments:**
- `--features` (**bắt buộc**): Đường dẫn đến file feature specification
- `--patterns` (**bắt buộc**): Đường dẫn đến file project patterns  
- `--output` (tùy chọn): Đường dẫn output, mặc định là `implementation-plan.md`

### Cách 3: Với Đường Dẫn Tuyệt Đối

Luôn sử dụng đường dẫn tuyệt đối để tránh lỗi:

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features /home/user/project/docs/features/task-management.md \
  --patterns /home/user/project/PATTERNS.md \
  --output /home/user/project/planning/task-plan.md
```

## Output

### Plan Document (Markdown)

Script tạo ra một file `implementation-plan.md` với cấu trúc:

```markdown
# Implementation Plan: [Tên Tính Năng]

## Overview
Tóm tắt về cách triển khai tính năng.

## Architecture Decisions
- Quyết định 1
- Quyết định 2

## Task Organization

### Phase 1: Foundation & Setup
- Task 1.1: ...
- Task 1.2: ...

#### Checkpoint: Foundation
- Verify points

### Phase 2: Core Implementation
- Task 2.1: ...
- Task 2.2: ...

#### Checkpoint: Core Features
- Verify points

### Phase 3: Refinement & Polish
- Task 3.1: ...
- Task 3.2: ...
- Task 3.3: ...

#### Checkpoint: Complete & Ready for Review
- Verify points

## Parallelization Opportunities
Các task nào có thể chạy song song

## Risks and Mitigations
Bảng rủi ro và giải pháp

## Success Criteria
Các điều kiện để xem tính năng đã hoàn thành

## Open Questions
Các câu hỏi cần giải quyết thêm
```

### JSON Output (Console)

```json
{
  "status": "success",
  "plan_file": "implementation-plan.md",
  "stats": {
    "tasks_generated": 9,
    "phases": 3,
    "estimated_scope": "Medium"
  },
  "summary": {
    "overview": "Implementation plan generated from specifications",
    "features_file": "./docs/features/auth-feature.md",
    "patterns_file": "./PATTERNS.md",
    "ready_for_review": true
  }
}
```

## Ví Dụ Thực Tế

### Scenario: Triển Khai Feature Authentication

**Bước 1: Chuẩn bị Feature Spec**

```markdown
# User Authentication Feature

## Overview
Implement user registration, login, password reset system.

## Feature Requirements
- User registration with email verification
- Login with email/password
- Password reset via email
- Session management

## Acceptance Criteria
- [ ] Registration endpoint works
- [ ] Verification email is sent
- [ ] Login creates session
- [ ] Session expires after 24h
- [ ] Password reset works

## Technical Considerations
- Use bcrypt for passwords
- JWT for session tokens
- Rate limit login attempts
- HTTPS only

## Integration Points
- User database
- Email service
- Session store (Redis)
- Audit logging
```

**Bước 2: Chuẩn bị Project Patterns**

```markdown
# Project Patterns

## Technology Stack
- Backend: NestJS
- Database: PostgreSQL
- ORM: Prisma
- Testing: Jest

## Code Style
- TypeScript with strict mode
- PascalCase for classes
- camelCase for functions
- DTOs for validation

## Testing Strategy
- Unit tests in Jest
- Integration tests with database
- Coverage target >80%

## API Conventions
- REST endpoints
- JSON responses
- Error codes and messages
```

**Bước 3: Chạy Script**

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features /project/docs/auth-spec.md \
  --patterns /project/PATTERNS.md \
  --output /project/planning/auth-plan.md
```

**Bước 4: Xem Plan Output**

```
{
  "status": "success",
  "plan_file": "/project/planning/auth-plan.md",
  "stats": {
    "tasks_generated": 9,
    "phases": 3,
    "estimated_scope": "Medium"
  }
}
```

**Bước 5: Review Plan**

Mở `auth-plan.md` để review:
- Các giai đoạn (Phase) có hợp lý không?
- Tasks có rõ ràng và có thể thực hiện được không?
- Có thiếu task nào không?
- Acceptance criteria có đầy đủ không?

## Tối Ưu Hóa Plan

### Tinh Chỉnh Thủ Công

Nếu plan cần điều chỉnh:

1. **Thêm task:** Thêm section mới trong phase phù hợp
2. **Xóa task:** Xóa task không cần thiết
3. **Sắp xếp lại:** Thay đổi thứ tự task nếu dependencies thay đổi
4. **Cập nhật acceptance criteria:** Làm cho tiêu chí rõ ràng hơn

### Chia Nhỏ Task Lớn

Nếu một task quá lớn:

```markdown
#### Task 2.1a: Implement User Registration Logic
- Accept email, password, name
- Validate input
- Hash password
- Create user in database

#### Task 2.1b: Setup Email Verification
- Generate verification token
- Send verification email
- Implement token validation
- Activate account after verification
```

### Thêm Rủi Ro

Nếu phát hiện rủi ro mới:

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Complex email integration | High | Early spike task for email setup |

## Workflow Hoàn Chỉnh

```
1. Viết Feature Spec
        ↓
2. Viết Project Patterns
        ↓
3. Chạy Feature Plan Generation
        ↓
4. Review Plan
        ↓
5. [Sửa Plan nếu cần] ←→ Review lại
        ↓
6. Approve Plan
        ↓
7. Triển khai theo Plan (dùng incremental-implementation skill)
        ↓
8. Verify Tasks (dùng test-driven-development skill)
        ↓
9. Hoàn tất Feature
```

## Mẹo & Kinh Nghiệm

### ✅ Nên Làm

- ✅ Viết spec chi tiết trước khi tạo plan
- ✅ Cập nhật project patterns file khi project thay đổi
- ✅ Review plan kỹ trước khi implement
- ✅ Commit plan vào git để tracking
- ✅ Dùng plan làm reference trong PR description

### ❌ Không Nên Làm

- ❌ Chạy script mà không chuẩn bị spec
- ❌ Ignore plan khi implement (nó có giá trị!)
- ❌ Không update plan khi requirement thay đổi
- ❌ Copy-paste plan mà không customize

## Troubleshooting

### Problem: "File not found"

```
Error: Feature file not found: /path/to/file.md
```

**Solution:**
- Kiểm tra đường dẫn có đúng không
- Kiểm tra file có tồn tại không
- Dùng `ls` để verify: `ls -la /path/to/file.md`

### Problem: "Could not parse markdown"

```
Warning: Could not parse markdown structure
```

**Solution:**
- Kiểm tra file markdown có heading không (`#`)
- Kiểm tra cấu trúc sections (`##`)
- Kiểm tra có bullet points không (`-`)

### Problem: "No tasks generated"

```
Warning: Plan generated but no tasks were extracted
```

**Solution:**
- Thêm acceptance criteria rõ ràng vào spec
- Thêm requirements vào spec
- Kiểm tra format markdown có đúng không

### Problem: "jq command not found"

```
Error: jq: command not found
```

**Solution:**
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# CentOS/RHEL
sudo yum install jq
```

## Liên Kết Hữu Ích

- **Ví dụ Feature Spec:** `examples/example-feature-spec.md`
- **Ví dụ Project Patterns:** `examples/example-project-patterns.md`
- **Skill SKILL.md:** `SKILL.md`
- **README:** `README.md`

## Hỗ Trợ & Phản Hồi

Nếu gặp vấn đề hoặc có ý kiến:
- Tạo issue trên GitHub
- Kiểm tra README section "Troubleshooting"
- Xem ví dụ để hiểu rõ hơn

---

**Phiên bản:** 1.0  
**Ngôn ngữ:** Tiếng Việt  
**Cập nhật:** 2026-04-12
