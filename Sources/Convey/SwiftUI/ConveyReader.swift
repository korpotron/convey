// Copyright © 2025 Toyota. All rights reserved.

import SwiftUI

public struct ConveyReader<Content: View>: View {
    private let content: (_ action: ConveyAction) -> Content

    @Environment(\.convey)
    private var convey

    public init(@ViewBuilder content: @escaping (ConveyAction) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(convey)
    }
}
