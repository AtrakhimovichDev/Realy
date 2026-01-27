import Foundation

protocol SubscriptionServiceProtocol {
    func hasActiveSubscription() async throws -> Bool
}

final class MockSubscriptionService: SubscriptionServiceProtocol {

    func hasActiveSubscription() async throws -> Bool {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        return Bool.random()
    }
}


