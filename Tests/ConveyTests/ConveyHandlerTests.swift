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

    @Test func debug_fatal() {
        #expect(ConveyHandler.fatal.debug == "fatal")
    }

    @Test func debug_unhandled() {
        #expect(ConveyHandler.unhandled.debug == "unhandled")
    }

    @Test func debug_done_Int() {
        let sut = ConveyHandler.done { (_: Int) in }
        #expect(sut.debug == "done Int")
    }

    @Test func debug_done_String() {
        let sut = ConveyHandler.done { (_: String) in }
        #expect(sut.debug == "done String")
    }

    @Test func debug_map_Int_to_String() {
        let sut = ConveyHandler.map { (_: Int) in "42" }
        #expect(sut.debug == "map Int -> String")
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
