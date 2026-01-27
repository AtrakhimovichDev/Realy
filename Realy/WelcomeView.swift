import SwiftUI

struct WelcomeView: View {

    // MARK: - Properties

    @StateObject private var viewModel: WelcomeViewModel

    // MARK: - Init

    init(totalDuration: Double = 2.0) {
        _viewModel = StateObject(
            wrappedValue: WelcomeViewModel(totalDuration: totalDuration)
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color("realyRed")
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image("realyIcon")

                Spacer()

                Text("A platform for finding and building meaningful friendships")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
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


