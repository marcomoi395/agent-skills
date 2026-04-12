# Project Patterns & Conventions

## Technology Stack

### Frontend
- **Framework:** React 18+ with TypeScript
- **State Management:** React Context API + custom hooks
- **UI Library:** Tailwind CSS v3
- **Build Tool:** Vite
- **Testing:** Jest + React Testing Library
- **Package Manager:** npm 9+

### Backend
- **Framework:** NestJS 9+
- **Runtime:** Node.js 18+
- **Database:** PostgreSQL 14+
- **ORM:** Prisma 4+
- **Validation:** class-validator
- **Testing:** Jest
- **Documentation:** Swagger/OpenAPI

### Shared
- **Language:** TypeScript 5+
- **Code Quality:** ESLint + Prettier
- **Git:** Conventional commits
- **CI/CD:** GitHub Actions

## Project Structure

```
.
├── apps/
│   ├── frontend/          # React application
│   │   ├── src/
│   │   │   ├── components/    # React components
│   │   │   ├── pages/         # Page components
│   │   │   ├── hooks/         # Custom hooks
│   │   │   ├── services/      # API clients
│   │   │   ├── types/         # TypeScript types
│   │   │   └── styles/        # Global styles
│   │   └── tests/
│   │
│   └── backend/           # NestJS application
│       ├── src/
│       │   ├── modules/        # Feature modules
│       │   │   └── auth/
│       │   │       ├── auth.controller.ts
│       │   │       ├── auth.service.ts
│       │   │       ├── auth.module.ts
│       │   │       └── dto/
│       │   ├── common/         # Shared utilities
│       │   ├── config/         # Configuration
│       │   ├── database/       # Database setup
│       │   └── main.ts
│       └── tests/
│
├── shared/                # Shared types and utils
│   ├── types/
│   └── utils/
│
├── database/              # Database migrations
│   └── migrations/
│
├── docs/                  # Documentation
│   ├── architecture/
│   ├── api/
│   └── decisions/         # Architecture Decision Records
│
└── scripts/               # Build and utility scripts
```

## Code Style & Conventions

### TypeScript
```typescript
// Always declare types explicitly
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Use interfaces for public contracts
interface UserDTO {
  id: string;
  email: string;
  name: string;
}

// Avoid 'any', use proper types
const processData = (data: UnknownObject[]): ProcessedData[] => {
  return data.map(item => transform(item));
};
```

### File Naming
- Components: `PascalCase` (e.g., `UserProfile.tsx`)
- Services: `camelCase` (e.g., `userService.ts`)
- Types/Interfaces: `PascalCase` (e.g., `User.ts`)
- Tests: Alongside source with `.test.ts` suffix
- Directories: `kebab-case` (e.g., `auth-service/`)

### Naming Conventions
- Classes: `PascalCase` with descriptive names (e.g., `UserAuthService`)
- Methods/Functions: `camelCase` starting with verb (e.g., `getUserById`, `createUser`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `API_BASE_URL`)
- Boolean variables: `isLoading`, `hasError`, `canDelete`
- Avoid single-letter variables except in loops

### Imports Organization
```typescript
// 1. Node built-ins
import fs from 'fs';
import path from 'path';

// 2. Third-party libraries
import React, { useState } from 'react';
import axios from 'axios';
import { Controller, Post, Body } from '@nestjs/common';

// 3. Internal absolute imports
import { UserService } from '@/services/user';
import { API_BASE_URL } from '@/config';

// 4. Internal relative imports
import { helper } from './helper';
```

## Testing Strategy

### Unit Tests
- Test individual functions and methods
- Mock external dependencies
- Aim for >80% coverage
- Location: `src/**/*.test.ts`

```typescript
describe('UserService.getUserById', () => {
  it('should return user with given id', () => {
    // Arrange
    const userId = 'user-123';
    const expectedUser = { id: userId, name: 'John' };
    
    // Act
    const result = userService.getUserById(userId);
    
    // Assert
    expect(result).toEqual(expectedUser);
  });
});
```

### Integration Tests
- Test module interactions and API endpoints
- Use test database or test containers
- Location: `tests/integration/`

```typescript
describe('POST /auth/login', () => {
  it('should return token for valid credentials', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'user@example.com', password: 'Password123' });
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('token');
  });
});
```

### E2E Tests
- Test complete user workflows
- Run against staging environment
- Location: `tests/e2e/`

## API Conventions

### REST Endpoints
```
GET    /api/v1/users           # List users
POST   /api/v1/users           # Create user
GET    /api/v1/users/:id       # Get user
PATCH  /api/v1/users/:id       # Update user
DELETE /api/v1/users/:id       # Delete user
```

### Response Format
```json
{
  "status": "success",
  "data": { "id": "123", "name": "John" },
  "meta": { "timestamp": "2025-01-15T10:00:00Z" }
}
```

### Error Format
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": [{ "field": "email", "message": "required" }]
  }
}
```

## NestJS Backend Patterns

### Module Structure
Each feature should be a self-contained module:
```typescript
// auth.module.ts
@Module({
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
```

### Service Pattern
Services contain business logic:
```typescript
@Injectable()
export class AuthService {
  async register(dto: RegisterDTO): Promise<User> {
    // Validate input
    // Hash password
    // Create user
    // Send verification email
    return user;
  }
}
```

### DTO Pattern
Use DTOs for request/response validation:
```typescript
export class RegisterDTO {
  @IsEmail()
  email: string;

  @MinLength(8)
  password: string;

  @IsString()
  name: string;
}
```

## React Frontend Patterns

### Component Structure
```typescript
interface UserProfileProps {
  userId: string;
  onUpdate?: (user: User) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({ 
  userId, 
  onUpdate 
}) => {
  const [user, setUser] = useState<User | null>(null);
  
  // Component logic
  
  return (
    <div>
      {/* JSX */}
    </div>
  );
};
```

### Hooks for State Management
```typescript
// Custom hook for data fetching
export const useUser = (userId: string) => {
  const [data, setData] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetchUser(userId)
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [userId]);

  return { data, loading, error };
};
```

## Database Schema Patterns

### Timestamps
All entities should include:
```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Soft Deletes (Optional)
```sql
deleted_at TIMESTAMP DEFAULT NULL
```

### Primary Keys
Use UUID for distributed systems:
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

## Git & Commit Conventions

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(auth): add email verification for registration

- Send verification email after registration
- Validate email before account activation
- Implement resend verification email endpoint

Closes #123
```

### Branch Naming
- Feature: `feature/user-authentication`
- Bug fix: `fix/login-redirect-issue`
- Refactor: `refactor/auth-service-structure`

## CI/CD Pipeline

### Testing
- Run on every commit
- Unit and integration tests must pass
- Coverage reports generated

### Build
- Lint check (ESLint)
- Type check (TypeScript)
- Build both frontend and backend

### Deploy (Optional)
- Automatic deploy on main branch
- Manual approval for production

## Documentation

### Code Documentation
- JSDoc comments for public functions
- Inline comments for non-obvious logic
- Type definitions are primary documentation

### API Documentation
- Use Swagger/OpenAPI annotations
- Auto-generate documentation from code
- Include examples and error codes

### Architecture Documentation
- Keep ADRs (Architecture Decision Records) in `docs/decisions/`
- Update PATTERNS.md when conventions change
- Link from code to relevant documentation

## Performance Guidelines

### Frontend
- Initial page load: < 3s on 4G
- Component render: < 100ms
- API calls: cache when possible

### Backend
- API response: < 200ms p99
- Database query: < 50ms p99
- Use indexes for frequent queries

### Database
- Connection pooling enabled
- Query optimization for large datasets
- Regular backups configured

## Security Best Practices

- Passwords: bcrypt with cost factor 12
- Secrets: Use environment variables, never commit
- HTTPS: Enforce on all endpoints
- CORS: Configure for allowed origins only
- Input validation: On all user inputs
- Rate limiting: On authentication endpoints
- Logging: Audit trail for sensitive operations

---

**Last Updated:** 2025-01-15  
**Maintained by:** Development Team  
**Version:** 1.0
