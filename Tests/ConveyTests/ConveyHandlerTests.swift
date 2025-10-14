import Testing
@testable import Convey

@Suite struct ConveyHandlerTests {
    @Test func example_1() {
        let (handler, spy) = ConveyHandler.spy()

        #expect(spy.records.count == 0)

        _ = handler.execute(42)
        _ = handler.execute("lorem")

        #expect(spy.records.count == 2)
        #expect(spy.records[0] as? Int == 42)
        #expect(spy.records[1] as? String == "lorem")
    }

    @Test func example_map() throws {
        let sut = ConveyHandler.map { (value: Int) in String(value) }
        let result = try sut.execute(31).unwrap()
        #expect(result as? String == "31")
    }
}

extension ConveyHandler.Result {
    struct SomeError: Error {
        let message: String
    }

    func unwrap() throws -> Any {
        switch self {
        case .done:
            throw SomeError(message: "")
        case let .next(value):
            return value
        }
    }
}
