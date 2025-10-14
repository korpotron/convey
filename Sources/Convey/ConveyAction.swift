import SwiftUI

public struct ConveyAction {
    indirect enum Parent {
        case some(ConveyAction)
        case none
    }

    private let parent: Parent
    private let handler: ConveyHandler

    private init(parent: Parent, handler: ConveyHandler) {
        self.parent = parent
        self.handler = handler
    }

    static func root(handler: ConveyHandler) -> Self {
        .init(parent: .none, handler: handler)
    }

    func chaining(_ handler: ConveyHandler) -> ConveyAction {
        .init(parent: .some(self), handler: handler)
    }

    public func callAsFunction(_ value: Any) {
        let result = handler.execute(value)

        switch (result, parent) {
        case (.done, _):
            break
        case let (.next(value), .some(parent)):
            parent(value)
        case (.next, .none):
            break
        }
    }
}

public extension ConveyAction {
    static var fatal: Self {
        .root(handler: .fatal)
    }

    static var unhandled: Self {
        .root(handler: .unhandled)
    }
}
