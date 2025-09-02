//
//  LoaderView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//

import SwiftUI

struct BouncingDotsLoader: View {
    @State private var scale: [CGFloat] = [0.5, 0.5, 0.5]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 15, height: 15)
                    .scaleEffect(scale[i])
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: scale[i]
                    )
            }
        }
        .onAppear {
            for i in 0..<3 {
                scale[i] = 1.0
            }
        }
    }
}


extension View {
    /// Print a deinit message when the view struct is released from view hierarchy (uses a helper object).
    func deferredPrintDeinit(_ name: String) -> some View {
        self.background(DeinitPrinter(name: name))
    }
}

private final class DeinitPrinter: View {
    let name: String
    init(name: String) {
        self.name = name
    }
    var body: some View { Color.clear }
    deinit { print("🔻 \(name) deinit") }
}
