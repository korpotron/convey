import SwiftUI

public struct ConveyHandler {
    public enum Result {
        case done
        case next(Any)
    }

    private let block: (Any) -> Result
    let debug: String?

    private init<T>(debug: String? = nil, block: @escaping (_ value: T) -> Result) {
        self.block = { value in
            if let value = value as? T {
                block(value)
            } else {
                .next(value)
            }
        }
        self.debug = debug
    }

    public func execute(_ value: Any) -> Result {
        block(value)
    }
}

public extension ConveyHandler {
    static func done<T>(debug: String? = nil, _ block: @escaping (T) -> Void) -> Self {
        .init(debug: debug ?? "done \(T.self)") { value in
            block(value)
            return .done
        }
    }

    static func map<A, B>(_ mapper: @escaping (A) -> B) -> Self {
        .init(debug: "map \(A.self) -> \(B.self)") { value in
            .next(mapper(value))
        }
    }

    static var fatal: Self {
        .done(debug: "fatal") { value in
            fatalError("Convey | fatal: \(type(of: value)).\(value)")
        }
    }

    static var unhandled: Self {
        .done(debug: "unhandled") { value in
            print("Convey | unhandled: \(type(of: value)).\(value)")
        }
    }
}
