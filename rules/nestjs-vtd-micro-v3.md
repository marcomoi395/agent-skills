# 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

# 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

# 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

# 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

# 5. Project-Specific Guidelines



## Project Info

- **Framework**: NestJS 9.2.1 with TypeScript 4.3.5
- **Architecture**: Controller → Service → Repository → Database
- **Package Manager**: Yarn
- **Timezone**: Vietnam (UTC+7)

## Config / Env Pattern

Config is centralized in `src/common/config/global.config.ts` and grouped by domain.

- `auth`: JWT, hotline, chatbot, triplayz, cronjob tokens
- `grpc`: user/account service URLs
- `crm`: auth, APIs, sync-noti status, sync options
- `sap`: auth, APIs, feature flags, request timeout
- `vgs`: ZNS/SMS/voice settings, branch name, API headers
- `vitaJava`: notification, spoon, application, wh_v4 groups
- `event`, `gift`, `webhook`, `mail`, `app`, `syncNoti`, `cronjob`, `onboarding`, `googleSheet`, `telegram`, `systemConfig`, `oauth`

Rule: read `global.config.ts` before adding new env vars or hardcoding config values.

## Service Layer (CRITICAL)

Services return **raw data only** (raw entities):

```typescript
// ❌ WRONG: Returns formatted response
async getItems(): Promise<AppResponseDto<ItemDto>> {
  return AppResponseDto.fromNestJsPagination(items, meta);
}

// ✅ CORRECT: Returns raw data
async getItems() {
  return { items, meta };
}
```

## DTOs & Validation

**Custom decorators** from `/common/decorators/`: `@IsValidText()`, `@IsValidNumber()`, `@IsValidDate()`, `@IsValidEnum()`, `@IsValidBoolean()`, `@IsValidUUID()`, `@IsValidUrl()`, `@IsValidObject()`, `@IsValidArray*`, `@AutoMapDecorator()`, `@NestedDecorator()`, `@AppResponse()` (Swagger)

Also used in practice: `IsValidArrayEnum`, `IsValidArrayPhoneNumber`, `IsValidArrayObject`, `IsValidEnumString`, `IsValidEnumNumber`, `IsOnlyOneFieldExist`, `RequireAllField`, `RequireOneOf`, `JustOneOfBaseOnEnum`, `Default`, `NestedArrayDecorator`.

**Pattern**:

```typescript
@Post('create')
@AppResponse(CreateItemResDto)
async create(@Body() dto: CreateItemReqDto) {
  const result = await this.service.create(dto);  // raw data
  return new AppResponseDto(result);  // wrap in controller
}
```

**Organization**: `dtos/req/[role]/`, `dtos/res/`, use `@ApiProperty()` for Swagger

## Error Handling

Use custom exceptions from `src/common/exceptions/custom-http.exception.ts` and `src/common/exceptions/custom-app.exception.ts`:

- `BadRequestExc` (400)
- `ConflictExc` (409)
- `NotFoundExc` (404)
- `ForbiddenExc` (403)
- `UnauthorizedExc`
- `InternalServerErrorExc` (500)
- `ExpectationFailedExc` (417)
- `AppBaseExc` for app-level status/meta mapping

```typescript
if (!item) {
  throw new NotFoundExc("Item not found");
}
```

## Query Filter Pattern

Use `@QueryFilter` decorator for list operations:

```typescript
// Constant: src/[feature]/constants/[feature]-query-alias.constant.ts
export const ITEM_QUERY_ALIAS = { ITEM: 'item' };

// Filter: src/[feature]/filters/[feature].admin.filter.ts
export class ItemAdminFilter {
  @QueryFilter({ order: 10 })
  applyNameFilter(queryBuilder: SelectQueryBuilder<Item>, dto: GetItemListAdminReqDto): void {
    if (dto.name?.trim()) {
      queryBuilder.andWhere(`${ITEM_QUERY_ALIAS.ITEM}.name ILIKE :name`, { name: `%${dto.name.trim()}%` });
    }
  }
}

// Service usage
async getList(dto: GetItemListAdminReqDto) {
  const qb = this.itemRepo.createQueryBuilder(ITEM_QUERY_ALIAS.ITEM).orderBy(`${ITEM_QUERY_ALIAS.ITEM}.createdAt`, 'DESC');
  await this.itemRepo.applyAllFilters(qb, dto, new ItemAdminFilter());
  return await paginate(qb, { limit: dto.limit, page: dto.page });
}
```

**Filter Best Practices**: Order (10, 20, 30...) controls sequence. Check parameter exists. Use `.trim()`. Use alias constants. One filter per concern.

## DateTime Utilities

**CRITICAL**: Use `/src/common/datetime.util.ts`, never `dayjs` directly.

Available: `getNowAtTimezone()`, `makeDateIsDateAtTimezone()`, `convertDateToDateAtTimezone()`, `getStartOfNowInTimezone()`, `getStartOfDateInTimezone()`, `getEndOfDateInTimezone()`, `getStartOfCurrentMonthInTimezone()`, `getStartOfMonthInTimezone()`, `compareDateWithDateInTimezone()`, `compareDateWithCurrent()`, `convertUnixSecondsToDateInTimezone()`, `getCurrentUnixSecondsInTimezone()`, `addDayToDate()`, `addMonthToDate()`, `addMinuteToDate()`, `subtractDaysInTimezone()`, `formatToString()`, `parseStringToDate()`

Wrong: `const now = dayjs().tz(TIME_ZONE);` | Correct: `const now = getNowAtTimezone();`

## Repository Pattern

**Responsibilities**: Query building via filter classes, data fetching, basic entity retrieval, NO business logic.

**BaseRepository Methods**: `findOneOrThrowExc()`, `applyAllFilters()`

```typescript
@Injectable()
export class ItemRepository extends BaseRepository<Item> {
  constructor(dataSource: DataSource) {
    super(Item, dataSource);
  }

  /**
   * Find item by id
   * @param id - Item id
   * @returns Promise<Item | null>
   */
  async findItemById(id: number): Promise<Item | null> {
    return await this.findOne({ where: { id } });
  }
}
```

## File Structure

```
vtd-service-*/src/
├── [feature]/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── dtos/req/[role]/
│   ├── dtos/res/
│   ├── entities/
│   ├── enums/
│   ├── constants/
│   ├── filters/
│   └── [feature].module.ts
├── common/
│   ├── config/
│   ├── dtos/
│   ├── exceptions/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── middlewares/
│   ├── decorators/
│   └── utils/
├── proto/
├── external/
└── main.ts
```

## Common Utilities (Don't Reinvent!)

**Response**: `new AppResponseDto(data)` in controllers only; use `AppResponseDto.fromNestJsPagination(data, meta)` for paginated responses

**Pagination**: `paginate(queryBuilder, { limit, page })`

**Validation**: Use custom decorators (not raw `@IsString()`, `@IsEmail()`)

**Logging**: `new Logger(MyService.name)` then `this.logger.log()` or `.error()`

**Helpers and base types**: check `src/common/helpers/index.ts`, `src/common/constants/index.constant.ts`, and `src/common/entities/base.entity.ts` before introducing new helpers, constants, or base entity columns.

## Commands Reference

**Root**: `yarn install`, `bash ./scripts/lint.sh` (read-only mode, do NOT run format script)

**Service**: `cd vtd-service-[name]-v3 && npm run build|dev|start:prod|lint`

**⚠️ CRITICAL - ESLint & Formatting**: 

- **NEVER run** `npm run lint -- --fix`, `eslint fix`, `prettier --write`, or any auto-formatting commands
- **ONLY use** read-only mode: `npm run lint`
- **FIX MANUALLY** in specific files instead of using automated formatters
- **NEVER commit** changes automatically after code modifications - this must be done explicitly by the user

## NestJS Patterns

- **DI**: `@Injectable()` with typed constructor parameters
- **Modules**: `imports: []` for dependencies, `providers: []` for services; use `ClientsModule.registerAsync()` for gRPC
- **Controllers**: Use role-based suffixes (admin, user)
- **Transactions**: Use `@Transactional()` for multi-step DB ops

## Implementation Checklist

**Planning**: Read existing feature. Check `/common/` utilities. Verify DTOs/Entities/Repos don't exist. Check filter classes. Review error codes.

**Implementation**: Create Request DTO. Create Response DTO. Create/Update Entity. Create/Update Repository. Create/Update Filter. Implement Service (raw data). Implement Controller (wrap AppResponseDto). Update Module. Add JSDoc. No `any` types. Single responsibility. Define constants.

**Quality**: Lint. Build. No type errors. No unused imports. Proper error handling.

## Quick Scenarios

### List items with filters

1. Create filter class with `@QueryFilter()` decorators
2. Create query alias constant
3. Create request/response DTOs
4. Use `applyAllFilters()` in service
5. Return paginated result with `paginate()`
6. Wrap with `new AppResponseDto()` or `AppResponseDto.fromNestJsPagination()` in controller

### Create/update item

1. Create request DTO with validation decorators
2. Create response DTO
3. Implement in service (return raw entity)
4. Call service from controller
5. Wrap result with `new AppResponseDto()`

### Work with dates

1. Import from `datetime.util.ts`
2. Never use `dayjs` directly
3. Use: `getNowAtTimezone()`, `getStartOfDateInTimezone()`, etc.

### Custom error handling

1. Use: `BadRequestExc`, `ConflictExc`, `NotFoundExc`
2. Import from `common/exceptions/custom-http.exception.ts`
3. Example: `throw new NotFoundExc('Item not found')`

### Complex database operation

1. Create repository method with clear naming
2. Use TypeORM query builder
3. Apply filters using filter classes
4. Use `@Transactional()` for multi-step ops
