# Feature Plan Generation Skill

## Overview

`feature-plan-generation` là một skill tự động hóa việc tạo tài liệu kế hoạch triển khai backend (implementation plan) từ các file thông tin tính năng (feature specs) và các pattern của dự án.

**Mục đích:** Tiết kiệm thời gian lập kế hoạch và đảm bảo tính nhất quán bằng cách tự động phân tích yêu cầu và tạo ra một tài liệu kế hoạch chi tiết, có cấu trúc rõ ràng. **Tối ưu hóa cho backend** - tập trung vào API design, database integration, service logic mà không tạo file test hay frontend.

## Tính Năng Chính

- **Phân tích tự động:** Đọc và phân tích các file đầu vào
- **Trích xuất yêu cầu:** Xác định các tính năng, tiêu chí chấp nhận, và ràng buộc
- **Phân tích pattern:** Trích xuất tech stack, kiến trúc, và quy ước từ tài liệu dự án
- **Tạo tác vụ:** Chia nhỏ tính năng thành các tác vụ có thể triển khai được
- **Tạo tài liệu plan:** Output một tài liệu plan có cấu trúc với các giai đoạn, tác vụ, và bước xác minh

## Cấu Trúc Skill

```
feature-plan-generation/
├── SKILL.md                    # Định nghĩa skill
└── scripts/
    └── generate-plan.sh        # Script chính để tạo plan
```

## Đầu Vào

### 1. Feature Specifications File (--features)
File markdown chứa thông tin chi tiết về tính năng:

```markdown
# Task Management Feature

## Overview
Cho phép người dùng tạo, chỉnh sửa, xóa và quản lý công việc.

## Requirements
- Người dùng có thể tạo công việc mới với tiêu đề và mô tả
- Mỗi công việc có trạng thái (todo, in-progress, done)
- Người dùng có thể đặt hạn chót cho công việc
- Công việc có thể được phân loại theo nhãn

## Acceptance Criteria
- [ ] Giao diện tạo công việc hoạt động
- [ ] Công việc được lưu vào database
- [ ] Người dùng có thể thay đổi trạng thái
- [ ] Danh sách công việc hiển thị đúng

## Constraints
- Phải hỗ trợ các trình duyệt hiện đại
- API response phải < 200ms
```

### 2. Project Patterns File (--patterns)
File markdown mô tả pattern và quy ước của dự án (backend-focused):

```markdown
# Project Patterns & Conventions

## Technology Stack
- **Backend:** NestJS, PostgreSQL, Prisma, TypeScript
- **API:** REST with request/response DTOs
- **Build:** npm/yarn

## Architecture
- **Backend:** Service-based architecture with Controllers, Services, Repositories
- **Database:** Normalized schema with migrations
- **API:** RESTful endpoints with consistent error handling

## Code Conventions
- **Naming:** PascalCase for classes, camelCase for functions
- **Files:** kebab-case for file names
- **DTOs:** Data Transfer Objects for validation
- **Imports:** Group by type (built-in, third-party, local)

## Project Structure
```
src/
├── modules/       # Feature modules
├── controllers/   # HTTP endpoints
├── services/      # Business logic
├── repositories/  # Database access
├── database/      # Migrations, schemas
└── common/        # Shared utilities
```
```

## Đầu Ra

Script tạo ra:

1. **Plan Document** (implementation-plan.md)
   - Overview và quyết định kiến trúc
   - Các giai đoạn (Phase) được chia nhỏ
   - Chi tiết từng tác vụ với tiêu chí chấp nhận
   - Các điểm kiểm tra (checkpoint)
   - Cơ hội song song hóa
   - Rủi ro và chiến lược giảm thiểu

2. **JSON Output** (stdout)
   ```json
   {
     "status": "success",
     "plan_file": "implementation-plan.md",
     "stats": {
       "tasks_generated": 12,
       "phases": 3,
       "estimated_scope": "Medium"
     },
     "summary": {
       "overview": "Plan description",
       "ready_for_review": true
     }
   }
   ```

## Cách Sử Dụng

### Cơ Bản

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/user-auth.md \
  --patterns ./PATTERNS.md
```

Kết quả: `implementation-plan.md`

### Với Output Custom

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/task-management.md \
  --patterns ./PROJECT_PATTERNS.md \
  --output ./planning/task-feature-plan.md
```

### Trong Agent Workflow

Khi agent sử dụng skill này:

1. Agent chuẩn bị feature spec và pattern files
2. Agent gọi script với đường dẫn file
3. Script sinh ra plan document
4. Agent đọc plan và trình bày cho user
5. User review và approve
6. Agent tiến hành triển khai theo plan

## Tiêu Chí Plan Được Tạo

### Phase 1: Foundation & Setup (2 tasks)
- Task 1.1: Analyze and Plan - Review specs, design approach
- Task 1.2: API Design & Database Schema - Design API endpoints, database schema

### Phase 2: Core Implementation (2 tasks)
- Task 2.1: Core Feature Implementation - Implement backend logic and services
- Task 2.2: API Implementation & Database Integration - Implement API endpoints, integrate with DB

### Phase 3: Refinement & Polish (2 tasks)
- Task 3.1: Error Handling & Logging - Add error handling and logging
- Task 3.2: Code Quality & Documentation - Clean code, add documentation

### Checkpoints
- Kiểm tra sau mỗi giai đoạn chính
- Xác minh build, API design, tích hợp
- Điểm dừng review trước tiếp tục

## Lợi Ích

✅ **Tiết kiệm thời gian:** Tự động hóa phần phân tích và tổ chức  
✅ **Nhất quán:** Tất cả plan theo cấu trúc thống nhất  
✅ **Rõ ràng:** Các tác vụ rõ ràng với tiêu chí chấp nhận  
✅ **Dự báo:** Ước tính phạm vi (Small/Medium/Large)  
✅ **Quản lý rủi ro:** Xác định rủi ro và giải pháp  
✅ **Hợp tác:** Dễ review và approve từ human engineer  

## Khác Biệt với Các Skill Khác

- **vs `planning-and-task-breakdown`:** Skill này tự động hóa phần phân tích và sinh task đầu tiên, giảm công việc thủ công
- **vs `spec-driven-development`:** Skill này dùng spec đã có để tạo plan, không dùng để viết spec
- **vs `documentation-and-adrs`:** Skill này tạo execution plan, không lưu trữ quyết định kiến trúc (ADRs)

## Yêu Cầu

- Bash shell
- `jq` để xử lý JSON output
- `sed` để thay thế text (thường có sẵn)
- `grep` để phân tích markdown (thường có sẵn)

## Lỗi Thường Gặp

### File không tìm thấy
```
Error: Feature file not found at path
```
**Giải pháp:** Kiểm tra đường dẫn file, sử dụng đường dẫn tuyệt đối

### Định dạng markdown không hợp lệ
```
Error: Could not parse markdown structure
```
**Giải pháp:** Đảm bảo file markdown có cấu trúc đúng (heading, sections, bullet points)

### Không tạo được task
```
Warning: Plan generated but no tasks were extracted
```
**Giải pháp:** Thêm acceptance criteria rõ ràng vào feature spec

## Cài Đặt

### Cho Claude Code
```bash
cp -r skills/feature-plan-generation ~/.claude/skills/
```

### Cho OpenCode  
Skill đã tích hợp sẵn, sử dụng qua `skill` tool

## Liên Quan

- `spec-driven-development` - Tạo spec trước khi dùng skill này
- `planning-and-task-breakdown` - Tinh chỉnh plan nếu cần
- `incremental-implementation` - Triển khai theo plan đã tạo
- `test-driven-development` - Viết test cho các task

---

**Phiên bản:** 1.0  
**Cập nhật lần cuối:** 2026-04-12  
**Trạng thái:** Active
