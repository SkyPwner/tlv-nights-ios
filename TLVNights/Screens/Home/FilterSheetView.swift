import Foundation
import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var when = "Tonight"
    @State private var genres: Set<String> = ["House", "Techno", "Hip-hop"]
    @State private var vibe = "Rooftop"
    @State private var maxDistance = 2.5
    @State private var friendsGoing = true
    @State private var liveNow = true
    @State private var stepFree = false
    @State private var noQueue = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TLVTheme.bg.ignoresSafeArea()
            TLVBackground().opacity(0.7).ignoresSafeArea()

            VStack(spacing: 0) {
                Capsule()
                    .fill(TLVTheme.fgDim)
                    .frame(width: 36, height: 4)
                    .padding(.top, 10)

                HStack {
                    Button("Reset") {
                        when = "Tonight"
                        genres = ["House", "Techno", "Hip-hop"]
                        vibe = "Rooftop"
                        maxDistance = 2.5
                    }
                    .foregroundColor(TLVTheme.fgMute)

                    Spacer()
                    DisplayText(text: "FILTERS", size: 22, alignment: .center)
                    Spacer()

                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(TLVTheme.amber)
                }
                .font(.system(size: 14))
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(TLVTheme.line).frame(height: 1)
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        FilterGroup(label: "When") {
                            wrappingChips(["Tonight", "Tomorrow", "This weekend", "Next week", "Pick date"], selection: $when)
                        }

                        FilterGroup(label: "Time of night") {
                            RangeBarView(fromLabel: "22:00", toLabel: "04:00", progress: 0.72)
                            HStack {
                                Text("18:00")
                                Spacer()
                                Text("00:00")
                                Spacer()
                                Text("06:00")
                            }
                            .font(.system(size: 10))
                            .foregroundColor(TLVTheme.fgDim)
                            .padding(.top, 8)
                        }

                        FilterGroup(label: "Distance from me") {
                            VStack(alignment: .leading, spacing: 8) {
                                Slider(value: $maxDistance, in: 0.5...6.0, step: 0.5)
                                    .tint(TLVTheme.amber)
                                Text("0 km -> \(String(format: "%.1f", maxDistance)) km")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(TLVTheme.amber)
                            }
                        }

                        FilterGroup(label: "Music / pick any", count: "\(genres.count) selected") {
                            FlowChipGrid(items: ["House", "Techno", "Hip-hop", "Disco", "Jazz", "Live indie", "Mizrahi", "Drum & bass", "Ambient"]) { item in
                                ChipButton(title: item, active: genres.contains(item)) {
                                    if genres.contains(item) {
                                        genres.remove(item)
                                    } else {
                                        genres.insert(item)
                                    }
                                }
                            }
                        }

                        FilterGroup(label: "Vibe") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                VibeOption(systemName: "rectangle.3.group", label: "Underground", desc: "Basements, no signage", active: vibe == "Underground") { vibe = "Underground" }
                                VibeOption(systemName: "sun.max", label: "Rooftop", desc: "Open air, sunset views", active: vibe == "Rooftop") { vibe = "Rooftop" }
                                VibeOption(systemName: "wineglass", label: "Cocktail bar", desc: "Sit-down, conversations", active: vibe == "Cocktail bar") { vibe = "Cocktail bar" }
                                VibeOption(systemName: "music.note", label: "Dance floor", desc: "Crowded, full energy", active: vibe == "Dance floor") { vibe = "Dance floor" }
                            }
                        }

                        FilterGroup(label: "Cover charge") {
                            HStack(spacing: 8) {
                                ForEach(["Free", "NIS", "NIS NIS", "NIS NIS NIS"], id: \.self) { price in
                                    PriceChip(title: price, active: price != "NIS NIS NIS")
                                }
                            }
                        }

                        FilterGroup(label: "Other") {
                            VStack(spacing: 0) {
                                FilterToggleRow(label: "Friends going", hint: "At least 1 friend confirmed", isOn: $friendsGoing)
                                FilterToggleRow(label: "Live now", hint: "Open right now", isOn: $liveNow)
                                FilterToggleRow(label: "Step-free access", hint: nil, isOn: $stepFree)
                                FilterToggleRow(label: "No queue (currently)", hint: nil, isOn: $noQueue, isLast: true)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 112)
                }
            }

            CTAButton(title: "Show 47 events") {
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 28)
            .background(
                LinearGradient(colors: [.clear, TLVTheme.bg, TLVTheme.bg], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .foregroundColor(TLVTheme.fg)
    }

    @ViewBuilder
    private func wrappingChips(_ items: [String], selection: Binding<String>) -> some View {
        FlowChipGrid(items: items) { item in
            ChipButton(title: item, active: selection.wrappedValue == item) {
                selection.wrappedValue = item
            }
        }
    }
}

private struct FilterGroup<Content: View>: View {
    let label: String
    var count: String?
    private let content: Content

    init(label: String, count: String? = nil, @ViewBuilder content: () -> Content) {
        self.label = label
        self.count = count
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundColor(TLVTheme.fgMute)
                Spacer()
                if let count {
                    Text(count)
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.amber)
                }
            }
            content
        }
    }
}

private struct FlowChipGrid<Content: View>: View {
    let items: [String]
    let content: (String) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

private struct RangeBarView: View {
    let fromLabel: String
    let toLabel: String
    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(TLVTheme.surface).frame(height: 6)
                Capsule()
                    .fill(TLVTheme.amber)
                    .frame(width: proxy.size.width * progress, height: 6)

                knob(label: fromLabel)
                    .position(x: proxy.size.width * 0.2, y: 3)
                knob(label: toLabel)
                    .position(x: proxy.size.width * progress, y: 3)
            }
        }
        .frame(height: 28)
    }

    private func knob(label: String) -> some View {
        Circle()
            .fill(TLVTheme.fg)
            .frame(width: 22, height: 22)
            .overlay(alignment: .top) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(TLVTheme.fg)
                    .fixedSize()
                    .offset(y: -22)
            }
    }
}

private struct VibeOption: View {
    let systemName: String
    let label: String
    let desc: String
    let active: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: systemName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(active ? TLVTheme.amber : TLVTheme.fg)
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(TLVTheme.fg)
                    .padding(.top, 2)
                Text(desc)
                    .font(.system(size: 11))
                    .foregroundColor(TLVTheme.fgMute)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(active ? TLVTheme.amber.opacity(0.08) : TLVTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                    .stroke(active ? TLVTheme.amber : TLVTheme.line, lineWidth: active ? 1.5 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
        }
        .buttonStyle(.plain)
    }
}

private struct PriceChip: View {
    let title: String
    let active: Bool

    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(active ? TLVTheme.amber : TLVTheme.fgMute)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(active ? TLVTheme.amber.opacity(0.1) : TLVTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(active ? TLVTheme.amber : TLVTheme.line, lineWidth: active ? 1.5 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct FilterToggleRow: View {
    let label: String
    let hint: String?
    @Binding var isOn: Bool
    var isLast = false

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(TLVTheme.fg)
                if let hint {
                    Text(hint)
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.fgMute)
                }
            }
        }
        .tint(TLVTheme.amber)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle().fill(TLVTheme.line).frame(height: 1)
            }
        }
    }
}
