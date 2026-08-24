# Onepazz SwiftUI - Claude Code Context

## Project Overview
**Onepazz** is a fitness and gym membership management app built with SwiftUI. It allows users to browse gyms, manage subscriptions, check in via QR codes, track activities, and view their fitness progress.

### Tech Stack
- **Language**: Swift 5.9+
- **Framework**: SwiftUI + Combine
- **Architecture**: MVVM with Repository Pattern
- **Networking**: Custom APIManager with async/await
- **Design**: Custom theme system with light/dark/custom themes

---

## Project Structure

```
Onepazz/
├── App/
│   ├── AppRouter.swift          # Main navigation controller
│   ├── AppEnvironment.swift     # Dependency injection container
│   ├── APIEnvironment.swift     # API configuration & base URLs
│   └── OnepazzApp.swift         # App entry point
├── Scenes/                      # Feature-based organization
│   ├── Auth/                    # Login, OTP verification
│   ├── Onboarding/              # First-time user flow
│   ├── Home/                    # Home screen with gym cards
│   ├── Explore/                 # Browse gyms and partners
│   ├── Activity/                # Activity tracking with calendar & charts
│   ├── Settings/                # User settings, theme switcher, profile
│   ├── QRScanner/               # QR code scanning for check-in
│   ├── Subscriptions/           # Payment & membership management
│   └── Gym/                     # Gym details & partner pages
├── DesignSystem/
│   ├── ThemeSystem.swift        # Theme configuration system
│   ├── ThemeManager.swift       # Theme state management
│   ├── ThemeExtensions.swift   # Theme environment & utilities
│   ├── CustomTabBar.swift       # Floating tab bar with blur effect
│   ├── Typography.swift         # Font system
│   ├── Spacing.swift            # Spacing constants
│   ├── Radius.swift             # Corner radius constants
│   └── AppColor.swift           # Color definitions
├── Services/
│   ├── Network/
│   │   ├── APIManager.swift              # Core HTTP client
│   │   ├── TargetType.swift              # API endpoint protocol
│   │   ├── RequestBuilder.swift          # Request construction
│   │   ├── AuthServiceTarget.swift       # Auth endpoints
│   │   ├── GymsServiceTarget.swift       # Gym endpoints
│   │   ├── SubscriptionsServiceTarget.swift
│   │   ├── CheckInServiceTarget.swift
│   │   └── DMSServiceTarget.swift        # Document upload
│   ├── Protocols/
│   │   ├── AuthRepositoryProtocol.swift
│   │   ├── GymsRepositoryProtocol.swift
│   │   └── SubscriptionsRepositoryProtocol.swift
│   ├── AuthRepository.swift
│   ├── GymsRepository.swift
│   ├── SubscriptionsRepository.swift
│   └── SessionManager.swift
├── Components/
│   ├── LoadingView.swift
│   ├── EmptyStateView.swift
│   ├── ErrorStateView.swift
│   └── ButtonStyles.swift
├── Core/
│   ├── ViewState.swift                   # Generic view state enum
│   ├── Extensions/
│   └── Protocols/
└── Localization/
    ├── L10n.swift                        # Localization helper
    └── en.lproj/Localizable.strings
```

---

## Architecture Patterns

### SOLID Principles
This project strictly follows SOLID principles (see `PROJECT_GUIDELINES.md` and `SOLID_PRINCIPLES.md`):
- **Single Responsibility**: Each class has one job
- **Open/Closed**: Extend via protocols, don't modify existing code
- **Liskov Substitution**: Protocol implementations are interchangeable
- **Interface Segregation**: Focused, specific protocols
- **Dependency Inversion**: Depend on abstractions, not concrete types

### MVVM Pattern
- **View**: SwiftUI views (UI only, no business logic)
- **ViewModel**: `ObservableObject` with `@Published` properties
- **Model**: Codable structs for API responses
- **Repository**: Data access layer between ViewModels and API

### Dependency Injection
- Use protocol abstractions for all dependencies
- `AppEnvironment` manages app-wide dependencies
- ViewModels accept dependencies via initializers

---

## Key Features & Implementation Notes

### 1. Theme System
**Location**: `DesignSystem/`

The app has a sophisticated theme system supporting unlimited custom themes:
- **ThemeConfiguration**: Data-driven theme structure (Codable)
- **ThemeManager**: `@ObservableObject` that manages current theme
- **ColorPalette**: Comprehensive color system with semantic colors
- **Built-in themes**: Light, Dark, Ocean
- **Usage**: Access via `@Environment(\.theme) var theme`

```swift
// Example usage
@Environment(\.theme) var theme

var body: some View {
    Text("Hello")
        .foregroundColor(Color(theme.colors.textPrimary))
        .background(Color(theme.colors.surface))
}
```

### 2. Custom Tab Bar
**Location**: `DesignSystem/CustomTabBar.swift`

Floating pill-shaped tab bar with:
- Ultra-thin material blur (liquid glass on iOS 18+)
- 4 main tabs + scan button
- Adaptive to light/dark mode
- Shadow for elevation

### 3. Activity Tracking
**Location**: `Scenes/Activity/ActivityView.swift`

Features:
- **CalendarWithPointerView**: Interactive calendar with pointer
- **ActivityChartCard**: Apple Watch-style concentric rings showing:
  - Move (calories)
  - Exercise (minutes)
  - Stand (hours)
- Progress bars with matching colors
- Uses theme colors for adaptability

### 4. QR Scanner
**Location**: `Scenes/QRScanner/QRScannerView.swift`

- AVFoundation-based QR scanning
- Camera runs on background queue
- Stops camera during loading states
- Shows success/error states after scan

### 5. Authentication Flow
**Location**: `Scenes/Auth/`

- Phone number login
- OTP verification
- Token-based session management
- `AppEnvironment` tracks auth state

### 6. API & Networking
**Pattern**: Service Target + Repository

**Service Target Example**:
```swift
enum AuthServiceTarget {
    case login(phoneNumber: String)
    case verifyOTP(phoneNumber: String, otp: String)
}

extension AuthServiceTarget: TargetType {
    var baseURL: URL { APIEnvironment.current.baseURL }
    var path: String {
        switch self {
        case .login: return "/v1/auth/login"
        case .verifyOTP: return "/v1/auth/verify"
        }
    }
    var httpMethod: HTTPMethod { .POST }
    var task: HTTPTask {
        switch self {
        case .login(let phone):
            return .requestJSONEncodable(AnyEncodable(["phone": phone]))
        case .verifyOTP(let phone, let otp):
            return .requestJSONEncodable(AnyEncodable(["phone": phone, "otp": otp]))
        }
    }
}
```

**Repository Example**:
```swift
protocol AuthRepositoryProtocol {
    func login(phoneNumber: String) async throws -> LoginResponse
}

class AuthRepository: AuthRepositoryProtocol {
    private let api: APIServiceProtocol

    init(api: APIServiceProtocol) {
        self.api = api
    }

    func login(phoneNumber: String) async throws -> LoginResponse {
        try await api.send(AuthServiceTarget.login(phoneNumber: phoneNumber), as: LoginResponse.self)
    }
}
```

### Base API Response Structure

**IMPORTANT**: All API endpoints return a standardized response format:

```json
{
    "code": 200,
    "success": true,
    "message": "success",
    "data": { ... }
}
```

**Implementation**: Use `BaseResponse<T>` wrapper (defined in `Services/Network/BaseResponse.swift`):

```swift
// Base response structure
struct BaseResponse<T: Decodable>: Decodable {
    let code: Int
    let success: Bool
    let message: String
    let data: T?
}

// Usage example:
struct User: Decodable {
    let id: String
    let name: String
    let email: String
}

// API call:
let response = try await api.send(target, as: BaseResponse<User>.self)
if response.success, let user = response.data {
    print(user.name)
}
```

**Common Response Patterns**:

1. **Single object**: `BaseResponse<User>`
2. **Array/List**: `BaseResponse<[Gym]>`
3. **Paginated**: `BaseResponse<PaginatedData<Activity>>`
4. **Success only (no data)**: `SuccessResponse` (alias for `BaseResponse<EmptyData>`)

**Example - Phone number request**:
```swift
// API Response:
// {
//   "code": 200,
//   "success": true,
//   "message": "success",
//   "data": { "phone": "087613339" }
// }

struct PhoneData: Decodable {
    let phone: String
}

let response = try await api.send(target, as: BaseResponse<PhoneData>.self)
guard response.success else {
    throw NSError(domain: "", code: response.code, userInfo: [NSLocalizedDescriptionKey: response.message])
}

if let phoneData = response.data {
    print(phoneData.phone) // "087613339"
}
```

---

## Design System

### Theme Colors
Access via `theme.colors.[colorName]`:
- **Primary**: Main brand color
- **Surface**: Card/surface backgrounds
- **SurfaceVariant**: Alternate surface color (more distinct)
- **TextPrimary/Secondary/Tertiary**: Text hierarchy
- **Accent**: Highlight color
- **Error/Warning/Success/Info**: Semantic colors
- **Card/CardHighlight**: Card backgrounds

### Typography
Use `Font.themed(fontConfig)` or direct system fonts:
- Large Title: 34pt bold
- Title1-3: 28pt, 22pt, 20pt
- Headline: 17pt semibold
- Body: 17pt regular
- Subhead: 15pt regular
- Caption: 12pt regular

### Spacing
Access via `Spacing.[size]`:
- xs: 4pt
- s: 8pt
- m: 12pt
- l: 16pt
- xl: 24pt
- xxl: 32pt

### Corner Radius
Access via `Radius.[size]`:
- xs: 4pt
- s: 8pt
- m: 12pt
- l: 16pt
- xl: 24pt

---

## Common Patterns & Best Practices

### 1. View State Management
```swift
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(Error)
}
```

### 2. Localization
```swift
"key".localized
"welcome_message".localized("John")  // with parameter
```

### 3. Navigation
```swift
// Push
NavigationLink(destination: DetailView()) { ... }

// Sheet
.sheet(isPresented: $showSheet) { ... }

// Dismiss
@Environment(\.dismiss) var dismiss
dismiss()
```

### 4. Loading States
```swift
@Published var isLoading = false

func fetchData() async {
    isLoading = true
    defer { isLoading = false }
    // API call
}
```

### 5. Error Handling
```swift
@Published var errorMessage: String?

do {
    let data = try await repository.fetch()
} catch {
    errorMessage = "Failed to load data"
    print("Error: \(error)")
}
```

### 6. Mockable ViewModels (REQUIRED)

**IMPORTANT**: All ViewModels MUST use protocol dependency injection for testability and SwiftUI previews.

#### Pattern:

```swift
// 1. Repository Protocol
protocol ActivityRepositoryProtocol {
    func getActivities() async throws -> BaseResponse<[Activity]>
}

// 2. ViewModel with Protocol Dependency
@MainActor
final class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Depend on protocol, not concrete type
    private let repository: ActivityRepositoryProtocol

    // Inject via initializer
    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }

    func loadActivities() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await repository.getActivities()
            guard response.success else {
                errorMessage = response.message
                return
            }
            activities = response.data ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// 3. Mock Repository for Previews/Tests
class MockActivityRepository: ActivityRepositoryProtocol {
    var shouldSucceed = true
    var mockActivities: [Activity] = [
        Activity(id: "1", type: "Gym", duration: 60),
        Activity(id: "2", type: "Badminton", duration: 45)
    ]

    func getActivities() async throws -> BaseResponse<[Activity]> {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)

        if shouldSucceed {
            return BaseResponse(
                code: 200,
                success: true,
                message: "Success",
                data: mockActivities
            )
        } else {
            return BaseResponse(
                code: 400,
                success: false,
                message: "Failed to load activities",
                data: nil
            )
        }
    }
}

// 4. View with Mockable ViewModel
struct ActivityView: View {
    @StateObject private var viewModel: ActivityViewModel

    // Accept repository for injection
    init(repository: ActivityRepositoryProtocol = ActivityRepository(api: APIManager())) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(repository: repository))
    }

    var body: some View {
        List(viewModel.activities) { activity in
            Text(activity.type)
        }
        .task { await viewModel.loadActivities() }
    }
}

// 5. SwiftUI Preview with Mock Data
#Preview {
    ActivityView(repository: MockActivityRepository())
}

// 6. Unit Test Example
class ActivityViewModelTests: XCTestCase {
    func testLoadActivitiesSuccess() async {
        // Given
        let mockRepo = MockActivityRepository()
        mockRepo.shouldSucceed = true
        let viewModel = ActivityViewModel(repository: mockRepo)

        // When
        await viewModel.loadActivities()

        // Then
        XCTAssertEqual(viewModel.activities.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadActivitiesFailure() async {
        // Given
        let mockRepo = MockActivityRepository()
        mockRepo.shouldSucceed = false
        let viewModel = ActivityViewModel(repository: mockRepo)

        // When
        await viewModel.loadActivities()

        // Then
        XCTAssertTrue(viewModel.activities.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
```

#### Benefits:
- ✅ **SwiftUI Previews work** without real API calls
- ✅ **Unit tests run fast** with predictable mock data
- ✅ **Develop UI independently** of backend
- ✅ **Easy to test error states** and edge cases
- ✅ **Follows Dependency Inversion Principle** (SOLID)

#### Quick Mock Repository Template:

```swift
class Mock[Feature]Repository: [Feature]RepositoryProtocol {
    var shouldSucceed = true
    var mockData: [YourModel] = []
    var errorMessage = "Mock error"

    func yourMethod() async throws -> BaseResponse<YourModel> {
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulate delay

        return BaseResponse(
            code: shouldSucceed ? 200 : 400,
            success: shouldSucceed,
            message: shouldSucceed ? "Success" : errorMessage,
            data: shouldSucceed ? mockData.first : nil
        )
    }
}
```

---

## Current State & Recent Changes

### Recent Updates (2026-03-09)
1. **Base API Response Structure**: Added standardized `BaseResponse<T>` wrapper for all API calls
   - Format: `{ "code": 200, "success": true, "message": "...", "data": {...} }`
   - File: `Services/Network/BaseResponse.swift`
2. **Mockable ViewModels Documentation**: Added comprehensive guide for creating testable ViewModels
   - Protocol dependency injection pattern
   - Mock repository template
   - SwiftUI preview examples
   - Unit test examples
3. **Login/OTP UI Fixes**:
   - Fixed real-time phone number formatting (LoginView)
   - Fixed button height jumping when showing loading spinner (LoginView & OTPVerificationView)

### Previous Updates (2026-03-08)
1. **Tab Bar Enhancement**: Added ultra-thin material blur with shadow for iOS-native liquid glass effect
2. **Activity Chart Redesign**: Changed from pie chart to Apple Watch-style concentric rings with progress bars
3. **Theme Integration**: Updated ActivityChartCard to use theme colors throughout

### Known Files with Modifications
- `CustomTabBar.swift`: Updated to use `.ultraThinMaterial` with shadows
- `ActivityView.swift`: Complete redesign of `ActivityChartCard` with rings + progress bars
- Uses `theme.colors.surfaceVariant` for card background

---

## Important Files to Reference

1. **PROJECT_GUIDELINES.md**: Comprehensive development rules & workflows
2. **SOLID_PRINCIPLES.md**: SOLID principles with examples
3. **README.md**: API patterns & transfer examples
4. **ThemeSystem.swift**: Complete theme configuration structure
5. **AppRouter.swift**: Main navigation logic

---

## Development Guidelines

### Before Adding New Features
1. Read `PROJECT_GUIDELINES.md`
2. Follow SOLID principles
3. Use protocol abstractions
4. Create in appropriate `Scenes/[Feature]/` directory
5. Use theme system for colors/spacing
6. Implement loading & error states
7. Add localization keys

### API Integration Checklist
1. Create/update `[Feature]ServiceTarget.swift`
2. **Define response models using `BaseResponse<T>` wrapper**
   - Wrap all API responses: `BaseResponse<YourData>`
   - For arrays: `BaseResponse<[YourModel]>`
   - For success only: `SuccessResponse`
3. Define request parameters (Encodable)
4. Create `[Feature]RepositoryProtocol.swift`
5. Implement `[Feature]Repository.swift`
6. **Create mockable ViewModel with protocol dependency injection**
   - ViewModel depends on protocol, not concrete implementation
   - Allows SwiftUI previews with mock data
   - Enables unit testing without real API calls
7. **Check `response.success` before accessing `response.data`**
8. Inject repository into ViewModel via initializer
9. Handle errors gracefully (check `response.message` for error details)

### UI/UX Standards
- Use theme colors, not hardcoded values
- Add shadows to floating elements
- Support light/dark mode automatically
- Use `.ultraThinMaterial` for modern blur effects
- Add bottom padding (100pt) to avoid tab bar overlap
- Use rounded caps (`.lineCap: .round`) for progress rings

---

## Testing & Debugging

### Debug Points
- API calls log via `RequestLogger`
- Check `AppEnvironment.isAuthenticated` for auth issues
- Theme changes propagate via `@Environment(\.theme)`
- Tab bar visibility controlled by `ScanButtonVisibility`

### Common Issues
1. **Tab bar overlapping content**: Add `.padding(.bottom, 100)` to ScrollView content
2. **Theme not updating**: Ensure view has `@Environment(\.theme) var theme`
3. **Colors too similar**: Use `surfaceVariant` instead of `surface` or `card`

---

## Notes for Claude
- Always check `PROJECT_GUIDELINES.md` before implementing features
- Use theme system for all colors (no hardcoded colors)
- Follow SOLID principles strictly
- Keep views lightweight, logic in ViewModels
- Use protocol abstractions for testability
- Add localization for all user-facing text
- Consider light/dark mode compatibility
