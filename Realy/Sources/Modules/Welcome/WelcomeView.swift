import SwiftUI

struct WelcomeView: View {

    @StateObject private var viewModel: WelcomeViewModel

    init(totalDuration: Double = 2.0) {
        _viewModel = StateObject(
            wrappedValue: WelcomeViewModel(totalDuration: totalDuration)
        )
    }

    var body: some View {
        ZStack {
            Color.realyRed
                .ignoresSafeArea()
            
            VStack {
                Spacer()

                Image(R.Images.realyIcon)
                    .opacity(viewModel.stage == .initial ? 0 : 1)
                    .animation(
                        .easeInOut(duration: viewModel.appearanceAnimationDuration),
                        value: viewModel.stage
                    )

                Spacer()
            }

            VStack {
                Spacer()

                if viewModel.stage != .initial {
                    HumanBadgeView(
                        isFilled: viewModel.stage == .humanBadgeFilled ||
                        (viewModel.stage == .finished && viewModel.hasSubscription),
                        animationDuration: viewModel.badgeFillAnimationDuration
                    )
                }

                Text(R.String.subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(40)
                    .opacity(viewModel.stage == .initial ? 0 : 0.5)
                    .animation(
                        .easeInOut(duration: viewModel.appearanceAnimationDuration),
                        value: viewModel.stage
                    )
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    WelcomeView()
}


