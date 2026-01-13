import XCTest
@testable import Onepazz

final class MultipartTests: XCTestCase {
    func testMultipartRequestBuildsWithBoundaryAndFile() throws {
        let data = "hello".data(using: .utf8)!
        let target = DMSService.uploadDocument(fileName: "hello.txt", mimeType: "text/plain", data: data, meta: ["folder":"inbox"])
        let req = try RequestBuilder.build(target, token: "tkn")
        let contentType = req.value(forHTTPHeaderField: "Content-Type")
        XCTAssertNotNil(contentType)
        XCTAssertTrue(contentType!.contains("multipart/form-data"))
        let body = String(data: req.httpBody ?? Data(), encoding: .utf8) ?? ""
        XCTAssertTrue(body.contains("Content-Disposition: form-data; name=\"file\"; filename=\"hello.txt\""))
        XCTAssertTrue(body.contains("Content-Type: text/plain"))
        XCTAssertTrue(body.contains("hello"))
        XCTAssertTrue(body.contains("name=\"folder\""))
        XCTAssertTrue(body.contains("inbox"))
    }
}