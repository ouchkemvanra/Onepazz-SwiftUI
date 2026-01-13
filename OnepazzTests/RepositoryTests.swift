import XCTest
@testable import Onepazz

final class RepositoryTests: XCTestCase {
    func testGymsRepositoryReturnsMockInDebug() async {
        let repo = GymsRepository(api: APIManager())
        let gyms = try? await repo.fetchGyms()
        XCTAssertNotNil(gyms)
        XCTAssertFalse(gyms!.isEmpty)
    }

    func testAuthRepositoryReturnsUserInDebug() async {
        let repo = AuthRepository(api: APIManager())
        let user = try? await repo.login(email: "t@onepazz.app", password: "1234")
        XCTAssertNotNil(user)
    }
}