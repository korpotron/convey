@testable import Convey

final class Spy {
    typealias Logger = (_ value: Any) -> Void

    private(set) var records: [Any] = []
    private init() {}

    static func build() -> (Spy, Logger) {
        let spy = Spy()
        let logger: Logger = { (value: Any) in
            spy.records.append(value)
        }
        return (spy, logger)
    }
}

extension ConveyHandler {
    static func spy() -> (ConveyHandler, Spy) {
        let (spy, logger) = Spy.build()
        let handler = ConveyHandler.done(logger)

        return (handler, spy)
    }
}

extension ConveyAction {
    static func spy() -> (ConveyAction, Spy) {
        let (handler, spy) = ConveyHandler.spy()
        let action = ConveyAction(parent: .none, handler: handler)
        return (action, spy)
    }
}
