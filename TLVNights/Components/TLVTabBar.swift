import SwiftUI

struct TLVTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(selection == tab ? TLVTheme.amber : .clear)
                            .frame(width: 4, height: 4)

                        Image(systemName: tab.systemImage)
                            .font(.system(size: 21, weight: .semibold))

                        Text(tab.title)
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(0.3)
                            .textCase(.uppercase)
                    }
                    .foregroundColor(selection == tab ? TLVTheme.amber : TLVTheme.fgDim)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .background(
            TLVTheme.bg.opacity(0.86)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(TLVTheme.line)
                .frame(height: 1)
        }
    }
}
