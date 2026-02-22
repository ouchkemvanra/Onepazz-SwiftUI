# Onepazz Project Guidelines & Development Rules

## Overview
This document contains the project guidelines and development rules for the Onepazz SwiftUI application. **Always consult this file before implementing any new features or making changes.**

---

## Architecture & Design Patterns

### SOLID Principles
This project strictly follows SOLID principles:

#### 1. Single Responsibility Principle (SRP)
- Each class/struct should have only one reason to change
- ViewModels handle state management for their specific view
- Repositories handle data operations for specific domains
- APIManager handles HTTP requests only
- Example: `AuthRepository` only handles authentication, `GymsRepository` only handles gym data

#### 2. Open/Closed Principle (OCP)
- Open for extension, closed for modification
- Use protocols and dependency injection to extend functionality
- Add new features without modifying existing code
- Example: Add new service targets without changing `APIManager`

#### 3. Liskov Substitution Principle (LSP)
- Subtypes must be substitutable for their base types
- Protocol implementations must honor the contract
- Repository implementations can be swapped without breaking functionality
- Example: Mock repositories can replace real ones in tests

#### 4. Interface Segregation Principle (ISP)
- Clients should not depend on interfaces they don't use
- Create focused, specific protocols
- Split large protocols into smaller, cohesive ones
- Example: `AuthRepositoryProtocol` vs `GymsRepositoryProtocol` instead of one large `RepositoryProtocol`

#### 5. Dependency Inversion Principle (DIP)
- Depend on abstractions, not concretions
- High-level modules should not depend on low-level modules
- Use protocol abstractions for all dependencies
- Example: ViewModels depend on `AuthRepositoryProtocol`, not `AuthRepository`

### MVVM Pattern
- Use MVVM (Model-View-ViewModel) architecture
- ViewModels should be `ObservableObject` classes with `@Published` properties
- Keep Views lightweight and focused on UI only (SRP)
- Business logic belongs in ViewModels or Services (SRP)

### Dependency Injection
- Follow Dependency Inversion Principle (DIP)
- Depend on protocol abstractions, not concrete implementations
- Use `AppEnvironment` for app-wide dependency management
- Support dependency injection in initializers for testability (OCP)

### Repository Pattern
- All API interactions go through Repository layer (SRP)
- Repository protocols define the contract (ISP)
- Concrete implementations handle API calls via `APIManager`
- Repositories are swappable for testing (LSP, DIP)

---

## Code Organization

### File Structure
```
Onepazz/
├── App/
│   ├── AppRouter.swift          # Main navigation & routing
│   ├── AppEnvironment.swift     # Dependency container
│   └── APIEnvironment.swift     # API configuration
├── Scenes/
│   ├── Auth/                    # Authentication screens
│   ├── QRScanner/              # QR scanning feature
│   ├── Onboarding/             # Onboarding flow
│   ├── Settings/               # Settings screens
│   └── [Feature]/              # Feature-based organization
├── Services/
│   ├── Network/
│   │   ├── APIManager.swift
│   │   ├── [Feature]ServiceTarget.swift
│   │   └── RequestBuilder.swift
│   ├── Protocols/
│   └── [FeatureRepository].swift
└── Models/
```

### File Naming Conventions
- Views: `[Feature]View.swift` (e.g., `LoginView.swift`)
- ViewModels: `[Feature]ViewModel.swift` (e.g., `LoginViewModel.swift`)
- Service Targets: `[Feature]ServiceTarget.swift` (e.g., `AuthServiceTarget.swift`)
- Repositories: `[Feature]Repository.swift` (e.g., `AuthRepository.swift`)
- Protocols: `[Feature]RepositoryProtocol.swift`

---

## API & Networking

### Service Target Pattern
All API endpoints follow the `TargetType` protocol:

```swift
enum [Feature]ServiceTarget {
    case endpointName(parameter: ParamType)
}

extension [Feature]ServiceTarget: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }
    var path: String { "/v1/[path]" }
    var httpMethod: HTTPMethod { .POST }
    var task: HTTPTask { .requestJSONEncodable(AnyEncodable(param)) }
    var headers: HTTPHeaders? { nil }
    var defaultHeaders: HTTPHeaders? { ["Accept": "application/json"] }
}
```

### API Request/Response
- Use `Encodable` for request parameters
- Use `Decodable` for response models
- Add `Equatable` to response models when needed for SwiftUI state management
- Wrap API calls in `Task` blocks for async/await

### API Manager Usage
```swift
let response = try await apiManager.send(
    ServiceTarget.endpoint(param: value),
    as: ResponseType.self
)
```

---

## UI/UX Standards

### Design System
- Use system fonts with specific weights (e.g., `.system(size: 17, weight: .semibold)`)
- Consistent spacing: 8, 12, 16, 24, 32, 40 points
- Consistent corner radius: 8, 12, 16 points
- Use opacity for subtle elements (e.g., `.opacity(0.6)`)

### Color Palette
- Primary Blue: `Color(red: 0.2, green: 0.6, blue: 0.86)`
- Dark Background: `Color(red: 0.15, green: 0.24, blue: 0.29)`
- Text Primary: `.black`
- Text Secondary: `.black.opacity(0.6)`
- Error Red: `.red`

### Loading & Error States
- Always show loading indicators during async operations
- Display user-friendly error messages
- Provide "Try Again" or "OK" buttons for error recovery
- Stop camera/sensor operations during loading states

### Animations
- Use `.easeInOut` for most transitions
- Duration: 0.2-0.3 seconds for quick interactions
- Use `.transition(.opacity.combined(with: .scale))` for overlays
- Use `withAnimation` for state-driven animations

---

## State Management

### Published Properties
```swift
@Published var propertyName: Type
@Published var isLoading = false
@Published var errorMessage: String?
```

### User Preferences
- Use `UserDefaults` for simple persistent state
- Implement `didSet` observers to auto-save changes
```swift
@Published var hasCompletedOnboarding: Bool {
    didSet {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
}
```

### Environment Objects
- Use `@EnvironmentObject` for shared app state
- Pass `AppEnvironment` down the view hierarchy
- Access via `@EnvironmentObject var env: AppEnvironment`

---

## Navigation & Routing

### Navigation Patterns
- Use `NavigationStack` for hierarchical navigation
- Use `.sheet()` for modal presentations
- Use `.fullScreenCover()` for full-screen modals
- Use `@Environment(\.dismiss)` to dismiss views

### Router Logic
- `AppRouter` handles top-level navigation
- Show onboarding before login on first launch
- Check `env.hasCompletedOnboarding` and `env.isAuthenticated`

---

## Camera & QR Scanning

### QR Scanner Implementation
- Use `AVCaptureSession` for camera access
- Run camera operations on background queue (`sessionQueue`)
- Update UI on main thread with `@MainActor`
- Stop camera when loading/processing
- Restart camera on error recovery
- Set `rectOfInterest` to limit scanning area

---

## Best Practices

### Code Quality
- Follow Single Responsibility Principle
- Follow Open/Closed Principle
- Keep functions small and focused
- Use meaningful variable and function names
- Add comments for complex logic only

### Error Handling
- Always handle errors in async operations
- Display user-friendly error messages
- Log errors for debugging: `print("Error: \(error)")`
- Provide recovery options (retry, dismiss, etc.)

### Performance
- Use `@StateObject` for owned objects
- Use `@ObservedObject` for passed objects
- Use `weak self` in closures to prevent retain cycles
- Run heavy operations on background queues

### Testing
- Design for testability with dependency injection
- Use protocol abstractions for mocking
- Support test doubles in initializers

---

## Git & Commits

### Commit Messages
- Use present tense ("Add feature" not "Added feature")
- Be descriptive but concise
- Reference issue numbers when applicable

### Branches
- `main`: Production-ready code
- Feature branches: `feature/[feature-name]`
- Bug fixes: `fix/[bug-description]`

---

## Common Workflows

### Adding a New Feature
1. **Check this file first**
2. Create feature directory in `Scenes/[Feature]/`
3. Create View and ViewModel files
4. Create Service Target if API calls needed
5. Create Repository if business logic needed
6. Update AppRouter for navigation if needed
7. Test the feature thoroughly

### Adding a New API Endpoint
1. Create/update `[Feature]ServiceTarget.swift`
2. Define request parameters struct (`Encodable`)
3. Define response model struct (`Decodable, Equatable`)
4. Add case to service target enum
5. Implement `TargetType` protocol extension
6. Use in Repository or ViewModel

### Adding a New Screen
1. Create in appropriate `Scenes/[Feature]/` directory
2. Follow naming convention: `[Feature]View.swift`
3. Create corresponding ViewModel if needed
4. Add navigation in AppRouter or parent view
5. Implement loading and error states
6. Add proper transitions/animations

---

## Notes
- This file should be updated as the project evolves
- All developers must read and follow these guidelines
- When in doubt, consult this file or discuss with the team
