import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = "techno"
    @State private var selectedType: SearchResultType = .all

    private var results: [SearchResult] {
        MockTLVData.searchResults.filter { result in
            selectedType == .all || result.type == selectedType
        }
    }

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 10) {
                        RoundIconButton(systemName: "chevron.left") {
                            dismiss()
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(TLVTheme.amber)
                            TextField("", text: $query)
                                .font(.system(size: 13))
                                .foregroundColor(TLVTheme.fg)
                                .tint(TLVTheme.amber)
                                .textInputAutocapitalization(.never)
                            Rectangle()
                                .fill(TLVTheme.amber)
                                .frame(width: 1.5, height: 16)
                                .opacity(0.9)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 40)
                        .background(TLVTheme.surface)
                        .overlay(Capsule().stroke(TLVTheme.amber, lineWidth: 1))
                        .clipShape(Capsule())
                    }
                    .padding(.top, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(SearchResultType.allCases, id: \.self) { type in
                                ChipButton(title: type.rawValue, active: selectedType == type) {
                                    selectedType = type
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Text("Top results / \(results.count == MockTLVData.searchResults.count ? 24 : results.count)")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.5)
                        .textCase(.uppercase)
                        .foregroundColor(TLVTheme.fgDim)
                        .padding(.top, 4)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        ForEach(results) { result in
                            if let eventID = result.eventID {
                                NavigationLink(value: AppRoute.eventDetail(eventID)) {
                                    SearchResultRow(result: result)
                                }
                                .buttonStyle(.plain)
                            } else {
                                SearchResultRow(result: result)
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct SearchResultRow: View {
    let result: SearchResult

    private var tileColor: Color {
        switch result.type {
        case .events, .all: return Color(hex: 0x3A2F24)
        case .venues: return TLVTheme.coral
        case .djs: return TLVTheme.amber
        case .friends: return TLVTheme.violet
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(result.type.tileLabel)
                .font(TLVTheme.display(size: 16))
                .fontWidth(.condensed)
                .tracking(0.5)
                .foregroundColor(result.type == .events ? TLVTheme.amber : TLVTheme.bg)
                .frame(width: 44, height: 44)
                .background(tileColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                DisplayText(text: result.title, size: 17, tracking: 0.6)
                    .lineLimit(1)
                Text(result.subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(TLVTheme.fgMute)
                    .lineLimit(1)
            }

            Spacer()

            if let goingCount = result.goingCount {
                Text("\(goingCount) GOING")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.5)
                    .foregroundColor(TLVTheme.fgDim)
                    .fixedSize()
            }
        }
        .padding(12)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}
