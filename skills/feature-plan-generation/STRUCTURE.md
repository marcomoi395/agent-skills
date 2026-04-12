# Cấu Trúc Skill: feature-plan-generation

## Tổng Quan

Skill này giúp tự động hóa việc tạo tài liệu kế hoạch triển khai từ feature specifications và project patterns.

## Cây Thư Mục

```
feature-plan-generation/
├── SKILL.md                          # Định nghĩa chính của skill (bắt buộc)
├── README.md                         # Tài liệu Tiếng Anh về skill
├── GUIDE_VI.md                       # Hướng dẫn chi tiết Tiếng Việt
│
├── scripts/
│   └── generate-plan.sh              # Script chính thực hiện công việc
│
└── examples/
    ├── example-feature-spec.md       # Ví dụ file feature specification
    └── example-project-patterns.md   # Ví dụ file project patterns
```

## Các File Chính

### 1. SKILL.md (Bắt Buộc)
- **Mục đích:** Định nghĩa skill theo tiêu chuẩn OpenCode
- **Nội dung:**
  - YAML frontmatter (name, description)
  - Overview - giới thiệu skill
  - When to Use - khi nào dùng
  - How It Works - quy trình làm việc
  - Usage - cách sử dụng với bash command
  - Output - định dạng output
  - Present Results - cách trình bày kết quả
  - Troubleshooting - giải quyết vấn đề
- **Dung lượng:** <500 dòng (theo best practice)

### 2. scripts/generate-plan.sh (Bắt Buộc)
- **Mục đích:** Script chính thực hiện tạo plan
- **Chức năng:**
  - Parse command-line arguments (--features, --patterns, --output)
  - Validate input files
  - Extract information từ markdown files
  - Generate plan document theo template
  - Output JSON result to stdout
- **Requirements:**
  - #!/bin/bash shebang
  - set -e (fail-fast)
  - Cleanup trap
  - Error handling
  - JSON output to stdout
  - Status messages to stderr

### 3. README.md (Tài Liệu)
- **Mục đích:** Tài liệu tiếng Anh chi tiết
- **Nội dung:**
  - Overview
  - Features chính
  - Cấu trúc skill
  - Đầu vào và đầu ra
  - Cách sử dụng
  - Lợi ích
  - Yêu cầu

### 4. GUIDE_VI.md (Hướng Dẫn Tiếng Việt)
- **Mục đích:** Hướng dẫn chi tiết bằng Tiếng Việt
- **Nội dung:**
  - Giới thiệu
  - Chuẩn bị đầu vào
  - Cách sử dụng
  - Output
  - Ví dụ thực tế
  - Tối ưu hóa
  - Mẹo & kinh nghiệm
  - Troubleshooting

### 5. examples/
- **example-feature-spec.md** - Mẫu file feature specification
- **example-project-patterns.md** - Mẫu file project patterns
- **Mục đích:** Giúp người dùng hiểu cấu trúc đầu vào

## Quy Trình Hoạt Động

```
User Input:
  --features <feature-spec.md>
  --patterns <project-patterns.md>
  --output <output-plan.md>
         ↓
   generate-plan.sh
         ↓
  ┌─────────────────┐
  │ Validate Files  │
  └────────┬────────┘
           ↓
  ┌─────────────────┐
  │ Parse Content   │ → Extract features, patterns, requirements
  └────────┬────────┘
           ↓
  ┌─────────────────┐
  │ Generate Tasks  │ → Create tasks, phases, checkpoints
  └────────┬────────┘
           ↓
  ┌─────────────────┐
  │ Create Document │ → Write implementation-plan.md
  └────────┬────────┘
           ↓
  ┌─────────────────┐
  │ Output JSON     │ → Report status, stats, summary
  └─────────────────┘
```

## Đầu Vào

### Feature Specification File (--features)
Markdown file mô tả:
- Tiêu đề và overview
- Requirements
- Acceptance criteria
- Technical considerations
- Integration points

### Project Patterns File (--patterns)
Markdown file mô tả:
- Technology stack
- Project structure
- Code conventions
- Testing strategy
- API conventions
- Database patterns
- Git conventions

## Đầu Ra

### Plan Document (implementation-plan.md)
```
- Overview
- Architecture Decisions
- Phase 1: Foundation & Setup
  - Task 1.1, 1.2, ...
  - Checkpoint
- Phase 2: Core Implementation
  - Task 2.1, 2.2, ...
  - Checkpoint
- Phase 3: Refinement & Polish
  - Task 3.1, 3.2, 3.3, ...
  - Checkpoint
- Parallelization Opportunities
- Risks and Mitigations
- Success Criteria
- Open Questions
```

### JSON Output (stdout)
```json
{
  "status": "success|error",
  "plan_file": "path/to/plan.md",
  "stats": {
    "tasks_generated": N,
    "phases": N,
    "estimated_scope": "Small|Medium|Large"
  },
  "summary": {
    "overview": "...",
    "ready_for_review": true
  }
}
```

## Cài Đặt & Phân Phối

### Cấu Trúc Định Dạng
```
skills/
  feature-plan-generation/        ← Directory (kebab-case)
    SKILL.md                       ← Required
    scripts/
      generate-plan.sh             ← Required, executable
  feature-plan-generation.tar.gz   ← Distribution package
```

### Cách Phân Phối
1. **Claude Code:** Copy folder vào `~/.claude/skills/`
2. **claude.ai:** Paste SKILL.md nội dung
3. **OpenCode:** Tích hợp sẵn, sử dụng qua skill tool

## Tiêu Chuẩn OpenCode

Skill này tuân thủ:

✅ **Naming:** `kebab-case` directory + uppercase `SKILL.md`
✅ **Structure:** Directory → SKILL.md + scripts/
✅ **Script:** Bash với shebang, set -e, cleanup trap
✅ **Output:** JSON to stdout, messages to stderr
✅ **Documentation:** <500 dòng (keep it lean)
✅ **Context Efficiency:** Scripts execute without loading context

## Ví Dụ Sử Dụng

### Scenario 1: Tạo Plan cho Feature Auth
```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features /project/docs/auth-feature.md \
  --patterns /project/PATTERNS.md
```

### Scenario 2: Custom Output Path
```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features /project/docs/tasks-feature.md \
  --patterns /project/PATTERNS.md \
  --output /project/planning/tasks-plan.md
```

### Scenario 3: Trong Agent Workflow
```
User: "Tạo plan cho authentication feature"
  ↓
Agent: Gọi skill feature-plan-generation
  ↓
Script: Generate plan từ feature spec + patterns
  ↓
Agent: Review + Present result to user
  ↓
User: Approve plan
  ↓
Agent: Proceed to implementation
```

## Khác Biệt với Các Skill Khác

| Skill | Mục Đích | Khi Nào Dùng |
|-------|----------|-------------|
| `feature-plan-generation` | Tạo plan từ spec + patterns | Có spec + patterns, cần tạo plan |
| `planning-and-task-breakdown` | Chia nhỏ task thủ công | Muốn tuỳ chỉnh deep dive vào plan |
| `spec-driven-development` | Viết spec | Spec chưa rõ, cần định nghĩa requirements |
| `incremental-implementation` | Triển khai task | Có plan, sẵn sàng code |
| `documentation-and-adrs` | Ghi lại quyết định | Lưu architecture decisions, ADRs |

## Debugging

### Test Script Trực Tiếp
```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features examples/example-feature-spec.md \
  --patterns examples/example-project-patterns.md \
  --output test-plan.md
```

### Kiểm Tra Output
```bash
# Xem file được tạo
cat test-plan.md

# Xem JSON output trong stderr
bash ... 2>&1 | grep "status"

# Test với missing file
bash ... --features nonexistent.md
```

### Logs & Error Checking
Script ghi lại:
- Status messages → stderr
- JSON result → stdout
- Cleanup automatically khi xong

## Best Practices

✅ Luôn sử dụng đường dẫn tuyệt đối  
✅ Commit plan vào git  
✅ Review plan kỹ trước implement  
✅ Update PATTERNS.md khi project thay đổi  
✅ Sửa plan nếu requirements thay đổi  

❌ Không chạy script mà không chuẩn bị input  
❌ Không ignore plan khi coding  
❌ Không copy-paste plan khác mà không customize  

## Mở Rộng

Nếu muốn thêm tính năng:

1. **Thêm option mới:** Sửa argument parsing trong script
2. **Thêm output format:** Thêm export format (JSON, PDF, etc)
3. **Thêm validation:** Tăng cường kiểm tra input
4. **Thêm intelligence:** Phân tích dependencies tốt hơn

---

**Phiên bản:** 1.0  
**Trạng thái:** Production Ready  
**Cập nhật:** 2026-04-12
