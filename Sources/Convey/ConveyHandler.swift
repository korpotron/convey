import SwiftUI

public struct ConveyHandler {
    public enum Result {
        case done
        case next(Any)
    }

    private let block: (Any) -> Result

    private init<T>(block: @escaping (_ value: T) -> Result) {
        self.block = { value in
            if let value = value as? T {
                block(value)
            } else {
                .next(value)
            }
        }
    }

    public func execute(_ value: Any) -> Result {
        block(value)
    }
}

public extension ConveyHandler {
    static func done<T>(_ block: @escaping (T) -> Void) -> Self {
        .init { value in
            block(value)
            return .done
        }
    }

    static func map<A, B>(_ mapper: @escaping (A) -> B) -> Self {
        .init { value in
            .next(mapper(value))
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
