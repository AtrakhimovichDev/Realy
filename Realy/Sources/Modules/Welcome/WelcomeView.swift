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
            Color("realyRed")
                .ignoresSafeArea()
            
            VStack {
                Spacer()

                Image("realyIcon")
                    .opacity(viewModel.stage == .initial ? 0 : 1)
                    .animation(.easeInOut(duration: viewModel.appearanceAnimationDuration), value: viewModel.stage)
                Spacer()

                if viewModel.stage == .elementsVisible ||
                    viewModel.stage == .humanBadgeFilled ||
                    viewModel.stage == .finished {
                    HumanBadgeView(
                        isFilled: viewModel.stage == .humanBadgeFilled ||
                        (viewModel.stage == .finished && viewModel.hasSubscription),
                        animationDuration: 0.3
                    )
                }

                Text("A platform for finding and building meaningful friendships")
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


