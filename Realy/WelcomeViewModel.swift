import Combine
import Foundation
import SwiftUI

@MainActor
final class WelcomeViewModel: ObservableObject {

    // MARK: - Nested Types

    enum Stage {
        case initial          // before anything is shown
        case logoAndSubtitle  // "Realy" + subtitle visible
        case humanBadge       // "HUMAN" badge visible (for subscribed users)
        case filled           // white filled state (for subscribed users)
        case finished         // animation finished
    }

    // MARK: - Published State

    @Published var stage: Stage = .initial
    @Published var hasSubscription: Bool = false

    // MARK: - Configuration

    let totalDuration: Double

    // MARK: - Dependencies

    private let subscriptionService: SubscriptionServiceProtocol

    // MARK: - Init

    init(
        totalDuration: Double = 2.0,
        subscriptionService: SubscriptionServiceProtocol = MockSubscriptionService()
    ) {
        self.totalDuration = totalDuration
        self.subscriptionService = subscriptionService
    }

    // MARK: - Public API

    func start() {
        Task {
            await runAnimation()
        }
    }

    // MARK: - Private

    private func runAnimation() async {
        stage = .initial

        do {
            let subscription = try await subscriptionService.hasActiveSubscription()
            hasSubscription = subscription
        } catch {
            hasSubscription = false
        }
        stage = .logoAndSubtitle
    }
}


