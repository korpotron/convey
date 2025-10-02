import SwiftUI

public struct ConveyHandler {
    public enum Result {
        case done
        case next(Any)
    }

    private let block: (Any) -> Result

    private init(block: @escaping (Any) -> Result) {
        self.block = block
    }

    public func execute(_ value: Any) -> Result {
        block(value)
    }

    static func process<T>(block: @escaping (T) -> Result) -> Self {
        .init { value in
            if let value = value as? T {
                block(value)
            } else {
                .next(value)
            }
        }
    }
}

public extension ConveyHandler {
    static func done<T>(_ block: @escaping (T) -> Void) -> Self {
        .process { value in
            block(value)
            return .done
        }
    }

    static func transform<A, B>(_ transformer: @escaping (A) -> B) -> Self {
        .process { value in
            let new = transformer(value)
            return .next(new)
        }
    }

    static var fatal: Self {
        .done { value in
            fatalError("Convey | fatal: \(type(of: value)).\(value)")
        }
    }

    static var unhandled: Self {
        .done { value in
            print("Convey | unhandled: \(type(of: value)).\(value)")
        }
    }
}
