import Combine
import Foundation
// MARK: Понимаю что проще часть анимаций сделать тут. Но мы таким образом нарушаем CleanArchitecture.
// В идеале viewModel не должен знать про SwiftUI. Нуи часть анимаций мы как будто размазываем.
// Часть в UI описано, часть здесь. Можно это покрутить и вс/ анимацию вынести во вью.
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
    let appearanceAnimationDuration: Double
    let badgeFillAnimationDuration: Double

    // MARK: - Dependencies

    private let subscriptionService: SubscriptionServiceProtocol

    // MARK: - Init

    init(
        totalDuration: Double = 2.0,
        appearanceAnimationDuration: Double = 1.0,
        badgeFillAnimationDuration: Double = 0.5,
        subscriptionService: SubscriptionServiceProtocol = MockSubscriptionService()
    ) {
        self.totalDuration = totalDuration
        self.appearanceAnimationDuration = appearanceAnimationDuration
        self.badgeFillAnimationDuration = badgeFillAnimationDuration
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

        try? await Task.sleep(nanoseconds: appearanceAnimationDuration.nanoseconds)

        do {
            let subscription = try await subscriptionService.hasActiveSubscription()
            hasSubscription = subscription
        } catch {
            hasSubscription = false
        }

        if hasSubscription {
            let elapsed = Date().timeIntervalSince(startTime)
            let remainingTime = totalDuration - elapsed - badgeFillAnimationDuration
            if remainingTime > 0 {
                try? await Task.sleep(nanoseconds: remainingTime.nanoseconds)
            }
            
            withAnimation(.easeInOut(duration: badgeFillAnimationDuration)) {
                stage = .humanBadgeFilled
            }
        }

        let totalElapsed = Date().timeIntervalSince(startTime)
        if totalElapsed < totalDuration {
            try? await Task.sleep(nanoseconds: (totalDuration - totalElapsed).nanoseconds)
        }

        stage = .finished
    }
}


