//
//  ContentView.swift
//  SlenderRow
//
//  Created by Сергей Прокопьев on 16.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isTapped = false
    let countRectangle = 6

    var layout: any Layout {
        isTapped ? DiagonalLayout() : HorisontalLayout()
    }

    var body: some View {
        AnyLayout(layout) {
            ForEach(0..<countRectangle) { index in
                RoundedRectangle(cornerRadius: 5)
                    .fill(.cyan)
                    .onTapGesture {
                        withAnimation {
                            isTapped.toggle()
                        }
                    }
            }
        }
        .safeAreaPadding(.zero)
    }
}

// MARK: - Layouts

struct HorisontalLayout: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout ()
    ) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewsCount = CGFloat(subviews.count)
        let spacingSum = 8.0 * (viewsCount - 1)
        let viewWidth = (width - spacingSum) / viewsCount
        let viewSize = CGSize(width: viewWidth, height: viewWidth)
        var currentX = bounds.minX + viewWidth / 2

        subviews.forEach({ subview in
            let position = CGPoint(x: currentX, y: bounds.midY)
            subview.place(
                at: position,
                anchor: .center,
                proposal: ProposedViewSize(viewSize)
            )
            currentX += viewWidth + spacingSum / (viewsCount - 1)
        })
    }
}

struct DiagonalLayout: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout ()
    ) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let height = proposal.replacingUnspecifiedDimensions().height
        let viewsCount = CGFloat(subviews.count)
        let viewHeight = height / viewsCount
        let viewSize = CGSize(width: viewHeight, height: viewHeight)
        var currentY = bounds.maxY
        var currentX = bounds.minX

        subviews.forEach({ subview in
            let position = CGPoint(x: currentX, y: currentY)
            subview.place(
                at: position,
                anchor: .bottomLeading,
                proposal: ProposedViewSize(viewSize)
            )
            currentY -= viewHeight
            currentX += (width - viewHeight) / (viewsCount - 1)
        })
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
