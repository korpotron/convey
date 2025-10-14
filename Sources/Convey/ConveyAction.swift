import SwiftUI

public struct ConveyAction {
    indirect enum Parent {
        case some(ConveyAction)
        case none
    }

    private let parent: Parent
    private let handler: ConveyHandler

    init(parent: Parent, handler: ConveyHandler) {
        self.parent = parent
        self.handler = handler
    }

    init(parent: Self, handler: ConveyHandler) {
        self.init(parent: .some(parent), handler: handler)
    }

    public func callAsFunction(_ value: Any) {
        let result = handler.execute(value)

        switch (result, parent) {
        case (.done, _):
            break
        case (.next(let value), .some(let parent)):
            parent(value)
        case (.next, .none):
            break
        }
    }
}

public extension ConveyAction {
    static var fatal: Self {
        .init(parent: .none, handler: .fatal)
    }

    static var unhandled: Self {
        .init(parent: .none, handler: .unhandled)
    }

    func chaining(_ handler: ConveyHandler) -> ConveyAction {
        .init(parent: self, handler: handler)
    }
}
