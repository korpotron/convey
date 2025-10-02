import Testing
@testable import Convey

@Suite struct HandlerTests {
    @Test func example_1() {
        let (handler, spy) = ConveyHandler.spy()

        #expect(spy.records.count == 0)

        _ = handler.execute(42)
        _ = handler.execute("lorem")

        #expect(spy.records.count == 2)
        #expect(spy.records[0] as? Int == 42)
        #expect(spy.records[1] as? String == "lorem")
    }
}
