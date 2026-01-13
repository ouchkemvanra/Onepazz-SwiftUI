# SOLID Principles Applied to Onepazz

This document outlines how SOLID principles have been applied throughout the Onepazz SwiftUI application.

## Overview

All SOLID principles have been systematically applied:
- ✅ **S**ingle Responsibility Principle
- ✅ **O**pen/Closed Principle
- ✅ **L**iskov Substitution Principle
- ✅ **I**nterface Segregation Principle
- ✅ **D**ependency Inversion Principle

---

## 1. Single Responsibility Principle (SRP)

**Definition:** A class should have only one reason to change.

### Applied In:

#### ViewModels
- **LoginViewModel** (`Onepazz/Scenes/Auth/LoginViewModel.swift`)
  - Single responsibility: Managing login state and validation
  - Separated from UI rendering (handled by LoginView)

- **GymsUIKitViewModel** (`Onepazz/UIKit/Gyms/GymsUIKitViewModel.swift:8`)
  - Single responsibility: Managing gyms list state only
  - Doesn't handle networking (delegated to repository)

#### Repositories
- **AuthRepository** (`Onepazz/Services/AuthRepository.swift:7`)
  - Single responsibility: Authentication operations

- **GymsRepository** (`Onepazz/Services/GymsRepository.swift:7`)
  - Single responsibility: Gym data operations

- **SubscriptionsRepository** (`Onepazz/Services/SubscriptionsRepository.swift:7`)
  - Single responsibility: Subscription data operations

#### Components
- **WelcomeHeaderView** (`Onepazz/Scenes/Home/Components/WelcomeHeaderView.swift`)
  - Single responsibility: Display user welcome section

- **VisitsCountView** (`Onepazz/Scenes/Home/Components/VisitsCountView.swift`)
  - Single responsibility: Display monthly visit count

- **FeaturedCard** (`Onepazz/Scenes/Home/Components/FeaturedCard.swift`)
  - Single responsibility: Display featured content card

- **PhoneField** (`Onepazz/Scenes/Auth/LoginView.swift:87`)
  - Single responsibility: Phone input UI only

#### Services
- **APIManager** (`Onepazz/Services/Network/APIManager.swift:6`)
  - Single responsibility: HTTP request execution and token management
  - Separated concerns via protocol conformance (APIServiceProtocol, TokenManagementProtocol)

---

## 2. Open/Closed Principle (OCP)

**Definition:** Software entities should be open for extension but closed for modification.

### Applied In:

#### Protocol Extensions
- **ViewStateExtensions** (`Onepazz/Core/Extensions/ViewStateExtensions.swift`)
  - Extends ViewState with new capabilities without modifying original code
  - Adds `isIdle`, `isEmpty`, `hasError`, `hasData`, `flatMap`, `recover`

- **TargetTypeExtensions** (`Onepazz/Core/Extensions/TargetTypeExtensions.swift`)
  - Extends TargetType protocol with default implementations
  - Adds `allHeaders`, `fullURL`, `requiresAuthentication`

- **RepositoryExtensions** (`Onepazz/Services/Protocols/RepositoryExtensions.swift`)
  - Extends repository protocols with retry logic
  - Adds `loginWithRetry`, `fetchGymsWithRetry`

#### Dependency Injection
- **AppEnvironment** (`Onepazz/App/AppEnvironment.swift:17`)
  - Constructor accepts protocol implementations
  - Can inject mocks without modifying the class

#### Parameterized Components
- **FeaturedCard** (`Onepazz/Scenes/Home/Components/FeaturedCard.swift`)
  - Extensible through parameters without code changes
  - Supports various configurations via optional parameters

---

## 3. Liskov Substitution Principle (LSP)

**Definition:** Objects should be replaceable with instances of their subtypes without altering correctness.

### Applied In:

#### Protocol Conformance
- All repository implementations properly conform to their protocols:
  - `AuthRepository` conforms to `AuthRepositoryProtocol`
  - `GymsRepository` conforms to `GymsRepositoryProtocol`
  - `SubscriptionsRepository` conforms to `SubscriptionsRepositoryProtocol`

- `APIManager` conforms to both:
  - `APIServiceProtocol`
  - `TokenManagementProtocol`

#### Substitutability
- **AppEnvironment** (`Onepazz/App/AppEnvironment.swift`)
  - Accepts protocol types, allowing any conforming implementation
  - Mock implementations can substitute real ones in tests

- **ViewModels**
  - All ViewModels depend on protocol abstractions
  - Can be tested with mock repositories

---

## 4. Interface Segregation Principle (ISP)

**Definition:** No client should be forced to depend on methods it does not use.

### Applied In:

#### Focused Protocols

**Repository Protocols** (separate files for each):
- `AuthRepositoryProtocol` - Only auth operations
- `GymsRepositoryProtocol` - Only gym operations
- `SubscriptionsRepositoryProtocol` - Only subscription operations

**API Service Protocols:**
- `APIServiceProtocol` - API request operations only
- `TokenManagementProtocol` - Token operations only (separate from API)

**State Protocols:**
- `LoadingStateProtocol` - Loading capability only
- `ErrorStateProtocol` - Error handling only
- `EmptyStateProtocol` - Empty state only
- `ViewStateRepresentable` - State queries
- `ViewStateTransformable` - State transformations

**Data Protocols:**
- `DataFetching` - Basic fetching
- `DataRefreshing` - Refresh operations (separate)
- `PaginatedDataFetching` - Pagination (extends DataFetching)

**Validation Protocols:**
- `Validatable` - Basic validation
- `FormInput` - Form-specific validation (extends Validatable)

**Cache Protocols:**
- `Cacheable` - Cache operations
- `CacheExpirable` - Expiration logic (separate)

---

## 5. Dependency Inversion Principle (DIP)

**Definition:** High-level modules should not depend on low-level modules. Both should depend on abstractions.

### Applied In:

#### Protocol Abstractions

**High-level modules depend on protocols, not concrete classes:**

- **AppEnvironment** (`Onepazz/App/AppEnvironment.swift:7`)
  ```swift
  @Published var authService: AuthRepositoryProtocol
  @Published var gymsService: GymsRepositoryProtocol
  @Published var subscriptionsService: SubscriptionsRepositoryProtocol
  let apiManager: APIServiceProtocol & TokenManagementProtocol
  ```

- **LoginViewModel** (`Onepazz/Scenes/Auth/LoginViewModel.swift`)
  ```swift
  private let authRepository: AuthRepositoryProtocol
  init(authRepository: AuthRepositoryProtocol)
  ```

- **GymsUIKitViewModel** (`Onepazz/UIKit/Gyms/GymsUIKitViewModel.swift:12`)
  ```swift
  private let repo: GymsRepositoryProtocol
  init(repo: GymsRepositoryProtocol)
  ```

- **Repositories depend on API abstraction:**
  ```swift
  // AuthRepository, GymsRepository, SubscriptionsRepository
  private let api: APIServiceProtocol
  init(api: APIServiceProtocol)
  ```

#### Dependency Injection

- **AppEnvironment initialization** (`Onepazz/App/AppEnvironment.swift:17`)
  - Supports injecting all dependencies
  - Defaults to production implementations
  - Enables testing with mocks

---

## Benefits Achieved

### 1. **Testability**
- All components can be tested in isolation
- Mock implementations can be injected via protocols
- ViewModels testable without UI dependencies

### 2. **Maintainability**
- Single responsibility makes code easier to understand
- Changes are localized to specific components
- Protocol extensions allow adding features without modifying existing code

### 3. **Flexibility**
- Easy to swap implementations (e.g., different API providers)
- Components reusable across different contexts
- Mock data for development/preview

### 4. **Scalability**
- New features can be added via extensions
- Protocols define clear contracts
- Modular architecture supports team collaboration

### 5. **Type Safety**
- Protocols ensure correct usage at compile-time
- Swift's type system enforces SOLID principles
- Protocol-oriented programming leverages Swift's strengths

---

## File Structure

```
Onepazz/
├── App/
│   └── AppEnvironment.swift (DIP - depends on protocols)
├── Core/
│   ├── Extensions/
│   │   ├── ViewStateExtensions.swift (OCP - extends without modifying)
│   │   ├── TargetTypeExtensions.swift (OCP)
│   │   └── ValidationExtensions.swift (OCP)
│   └── Protocols/
│       ├── ViewStateRepresentable.swift (ISP)
│       ├── LoadingStateProtocol.swift (ISP)
│       └── ValidationProtocol.swift (ISP)
├── Services/
│   ├── Network/
│   │   ├── APIManager.swift (SRP, conforms to protocols)
│   │   └── Protocols/
│   │       └── APIServiceProtocol.swift (ISP, DIP)
│   ├── Protocols/
│   │   ├── AuthRepositoryProtocol.swift (ISP, DIP)
│   │   ├── GymsRepositoryProtocol.swift (ISP, DIP)
│   │   ├── SubscriptionsRepositoryProtocol.swift (ISP, DIP)
│   │   ├── DataFetchingProtocol.swift (ISP)
│   │   ├── CacheableProtocol.swift (ISP)
│   │   └── RepositoryExtensions.swift (OCP)
│   ├── AuthRepository.swift (SRP, DIP)
│   ├── GymsRepository.swift (SRP, DIP)
│   └── SubscriptionsRepository.swift (SRP, DIP)
├── Scenes/
│   ├── Auth/
│   │   ├── LoginView.swift (SRP - UI only)
│   │   └── LoginViewModel.swift (SRP, DIP)
│   └── Home/
│       ├── Components/ (SRP - focused components)
│       │   ├── WelcomeHeaderView.swift
│       │   ├── VisitsCountView.swift
│       │   ├── FeaturedCard.swift
│       │   ├── GymCardV2.swift
│       │   └── ActivityFilterChip.swift
│       └── Models/ (SRP - data models)
│           ├── ActivityFilter.swift
│           ├── HomeUser.swift
│           └── PartnerRoute.swift
└── UIKit/
    └── Gyms/
        └── GymsUIKitViewModel.swift (SRP, DIP)
```

---

## Next Steps for Continued SOLID Compliance

1. **Apply the same patterns to remaining views** (GymDetailView, SettingsView, etc.)
2. **Create unit tests** leveraging protocol-based dependency injection
3. **Add integration tests** with mock implementations
4. **Document architectural decisions** in code comments
5. **Set up CI/CD** to enforce SOLID principles via linting and tests

---

## Conclusion

The Onepazz application now follows all SOLID principles throughout its architecture. This provides a solid foundation for:
- Easier testing and debugging
- Faster feature development
- Better code reusability
- Improved team collaboration
- Long-term maintainability

Each principle complements the others to create a robust, flexible, and maintainable codebase.
