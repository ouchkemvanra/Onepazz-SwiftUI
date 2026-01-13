import Foundation
#if DEBUG
enum RequestLogger { static func logCurl(_ request: URLRequest) { print("curl placeholder") } }
#endif
