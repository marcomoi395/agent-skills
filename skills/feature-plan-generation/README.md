# Feature Plan Generation Skill

## Overview

`feature-plan-generation` là một skill tự động hóa việc tạo tài liệu kế hoạch triển khai (implementation plan) từ các file thông tin tính năng (feature specs) và các pattern của dự án.

**Mục đích:** Tiết kiệm thời gian lập kế hoạch và đảm bảo tính nhất quán bằng cách tự động phân tích yêu cầu và tạo ra một tài liệu kế hoạch chi tiết, có cấu trúc rõ ràng.

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
File markdown mô tả pattern và quy ước của dự án:

```markdown
# Project Patterns & Conventions

## Technology Stack
- **Frontend:** React 18, TypeScript, Tailwind CSS
- **Backend:** NestJS, PostgreSQL, Prisma
- **Testing:** Jest, React Testing Library
- **Build:** Vite, npm

## Architecture
- **Frontend:** Component-based, hooks for state management
- **Backend:** Service-based architecture with DTOs
- **Database:** Normalized schema with migrations
- **API:** REST with consistent error handling

## Code Conventions
- **Naming:** PascalCase for classes, camelCase for functions
- **Files:** kebab-case for file names
- **Imports:** Group by type (built-in, third-party, local)
- **Tests:** Co-located with source code, .test.ts suffix

## Testing Strategy
- Unit tests for business logic
- Integration tests for API endpoints
- E2E tests for user flows
- Coverage target: >80%

## Project Structure
```
src/
├── components/    # React components
├── services/      # Business logic
├── api/          # API integration
├── types/        # TypeScript types
└── tests/        # Test files
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

### Phần I: Foundation & Setup
- Phân tích và lập kế hoạch chi tiết
- Chuẩn bị cấu hình và môi trường

### Phần II: Core Implementation  
- Triển khai tính năng chính
- Tích hợp với các hệ thống hiện có

### Phần III: Refinement & Polish
- Xử lý lỗi và các trường hợp biên
- Kiểm thử toàn diện
- Chất lượng code và tài liệu

### Checkpoints
- Kiểm tra sau mỗi giai đoạn chính
- Xác minh build, test, tích hợp
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
