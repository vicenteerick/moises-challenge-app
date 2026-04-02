//
//  DraggableSliderView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 30/03/26.
//

import MCDesignSystem
import SwiftUI

struct DraggableSliderView: View {
    private let circleDiameter: CGFloat = 24
    private let dragThreshold: CGFloat = 10

    private var progress: CGFloat {
        guard maximum > 0 else { return 0 }
        let p = value / maximum
        return CGFloat(min(1, max(0, p)))
    }

    @Binding var value: Double

    var maximum: Double
    var onEditingChanged: (Bool) -> Void

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 8)
                    .foregroundStyle(Color.ds.grayScale200)

                Capsule()
                    .frame(width: width * progress, height: 8)
                    .foregroundStyle(Color.ds.grayScale100)

                Circle()
                    .frame(width: circleDiameter, height: circleDiameter)
                    .foregroundStyle(Color.ds.base)
                    .shadow(radius: 3)
                    .offset(x: (width - circleDiameter) * progress)
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: dragThreshold)
                    .onChanged { gesture in
                        let x = min(max(gesture.location.x, 0), width)
                        let progress = width > 0 ? Double(x / width) : 0
                        value = maximum > 0 ? min(max(progress * maximum, 0), maximum) : 0
                        
                        onEditingChanged(true)
                    }
                    .onEnded { _ in
                        onEditingChanged(false)
                    }
            )
        }
        .frame(height: circleDiameter)
    }
}
