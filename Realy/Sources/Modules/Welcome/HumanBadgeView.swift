import SwiftUI

struct HumanBadgeView: View {
    
    let isFilled: Bool
    let animationDuration: Double
    
    var body: some View {
        Text("HUMAN")
            .font(.system(size: 24, weight: .medium))
            .foregroundColor(isFilled ? Color("realyRed") : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isFilled {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 1)
                    }
                }
            )
            .transition(.scale.combined(with: .opacity))
            .animation(.easeInOut(duration: animationDuration), value: isFilled)
    }
}

#Preview {
    VStack(spacing: 20) {
        HumanBadgeView(isFilled: false, animationDuration: 0.3)
        HumanBadgeView(isFilled: true, animationDuration: 0.3)
    }
    .padding()
    .background(Color.red)
}

