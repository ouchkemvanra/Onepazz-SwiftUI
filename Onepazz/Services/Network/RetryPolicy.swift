import Foundation

struct RetryPolicy {
    let maxRetries: Int
    let baseDelay: TimeInterval

    static let `default` = RetryPolicy(maxRetries: 3, baseDelay: 0.5)

    func delay(for attempt: Int) -> TimeInterval {
        guard attempt > 0 else { return 0 }
        let jitter = Double.random(in: 0...0.2)
        return pow(2.0, Double(attempt - 1)) * baseDelay * (1.0 + jitter)
    }
}