//
//  GridViewHeader.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/19/20.
//

import SwiftUI

extension HorizontalAlignment {
    private enum UnderlineLeading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }

    static let underlineLeading = HorizontalAlignment(UnderlineLeading.self)
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}


struct GridViewHeader : View {

    @State private var activeIdx: Int = 0
    @State private var w: [CGFloat] = [0, 0, 0, 0]
//    let items: [String]

    var body: some View {
        return VStack(alignment: .underlineLeading) {
            HStack {
                Text("All")
                    .modifier(MagicStuff(activeIdx: $activeIdx, idx: 0))
                    .background(TextGeometry())
                    .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[0] = $0 })

                Spacer()

                Text("New")
                    .modifier(MagicStuff(activeIdx: $activeIdx, idx: 1))
                    .background(TextGeometry())
                    .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[1] = $0 })

                Spacer()

                Text("Liked")
                    .modifier(MagicStuff(activeIdx: $activeIdx, idx: 2))
                    .background(TextGeometry())
                    .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[2] = $0 })

                Spacer()

                Text("How to Create")
                    .modifier(MagicStuff(activeIdx: $activeIdx, idx: 3))
                    .background(TextGeometry())
                    .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[3] = $0 })

                }
                .frame(height: 50)
                .padding(.horizontal, 10)
            Rectangle()
                .alignmentGuide(.underlineLeading) { d in d[.leading]  }
                .frame(width: w[activeIdx],  height: 2)
                .animation(.linear)
        }
    }
}

struct TextGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().fill(Color.clear).preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct MagicStuff: ViewModifier {
    @Binding var activeIdx: Int
    let idx: Int

    func body(content: Content) -> some View {
        Group {
            if activeIdx == idx {
                content.alignmentGuide(.underlineLeading) { d in
                    return d[.leading]
                }.onTapGesture { self.activeIdx = self.idx }

            } else {
                content.onTapGesture { self.activeIdx = self.idx }
            }
        }
    }
}
