import Combine
import Foundation
import SwiftUI

@MainActor
final class WelcomeViewModel: ObservableObject {

    enum Stage {
        case initial
        case elementsVisible
        case humanBadgeFilled
        case finished
    }

    // MARK: - Published State

    @Published var stage: Stage = .initial
    @Published var hasSubscription: Bool = false

    // MARK: - Configuration

    let totalDuration: Double
    let appearanceAnimationDuration: Double = 0.5

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
        let startTime = Date()
        stage = .initial

        withAnimation(.easeInOut(duration: appearanceAnimationDuration)) {
            stage = .elementsVisible
        }

        try? await Task.sleep(nanoseconds: UInt64(appearanceAnimationDuration * 1_000_000_000))
        
        do {
            let subscription = try await subscriptionService.hasActiveSubscription()
            hasSubscription = subscription
        } catch {
            hasSubscription = false
        }

        if hasSubscription {
            let elapsed = Date().timeIntervalSince(startTime)
            let remainingTime = totalDuration - elapsed - 0.3
            if remainingTime > 0 {
                try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                stage = .humanBadgeFilled
            }
        }

        let totalElapsed = Date().timeIntervalSince(startTime)
        if totalElapsed < totalDuration {
            try? await Task.sleep(nanoseconds: UInt64((totalDuration - totalElapsed) * 1_000_000_000))
        }

        stage = .finished
    }
}


