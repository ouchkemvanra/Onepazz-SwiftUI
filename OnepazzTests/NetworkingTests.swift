import XCTest
@testable import Onepazz

final class NetworkingTests: XCTestCase {
    func testAPIManagerDecodesWrappedPayload() async throws {
        let session = URLSession.mockSession()
        let api = APIManager(session: session)

        let sample = """
        { "status":"success", "data": { "name":"Gym A", "city":"Phnom Penh", "isOpenNow": true, "id":"g1" } }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let resp = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (resp, sample)
        }

        struct One: Decodable { let name: String; let city: String; let isOpenNow: Bool; let id: String }
        let result: One = try await api.send(GymsService.list, as: One.self)
        XCTAssertEqual(result.name, "Gym A")
    }

    func testRequestBodyIncludesBaseParams() async throws {
        let session = URLSession.mockSession()
        let api = APIManager(session: session)

        let expected = """
        { "status":"success", "data": { "user":{"id":"u1","name":"n","email":"e","token":"t"} } }
        """.data(using: .utf8)!

        var capturedBody: Data?
        MockURLProtocol.requestHandler = { request in
            capturedBody = request.httpBody
            let resp = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type":"application/json"])!
            return (resp, expected)
        }

        let _ : User = try await api.send(AuthService.login(parameter: LoginParam(email: "e", password: "p")), as: User.self)
        XCTAssertNotNil(capturedBody)
        if let body = capturedBody,
           let json = try? JSONSerialization.jsonObject(with: body) as? [String:Any] {
            XCTAssertNotNil(json["base"])
            XCTAssertNotNil(json["payload"])
        } else {
            XCTFail("Body not encoded as expected")
        }
    }
}