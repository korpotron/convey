import Testing
@testable import Convey

@Suite struct ActionTests {
    @Test func example_1() {
        let (sut, spy) = ConveyAction.spy()
        #expect(spy.records.count == 0)

        sut(42)

        #expect(spy.records.count == 1)
        #expect(spy.records[0] as? Int == 42)
    }

    @Test func example_2() {
        let (sut1, spy1) = ConveyAction.spy()
        let (spy2, logger2) = Spy.build()

        let sut2 = sut1.chaining(.done { (value: Int) in
            logger2(value)
        })

        sut2(42)
        sut2("lorem")

        sut1(17)
        sut1("ipsum")

        #expect(spy1.records.count == 3)
        #expect(spy1.records[0] as? String == "lorem")
        #expect(spy1.records[1] as? Int == 17)
        #expect(spy1.records[2] as? String == "ipsum")

        #expect(spy2.records.count == 1)
        #expect(spy2.records[0] as? Int == 42)
    }

    @Test func example_3() {
        let (sut1, spy1) = ConveyAction.spy()
        let (spy2, logger2) = Spy.build()
        let (spy3, logger3) = Spy.build()

        let sut2 = sut1.chaining(.done { (value: Int) in
            logger2(value)
        })

        let sut3 = sut2.chaining(.done { (value: FooBar) in
            logger3(value)
        })

        sut3(3)
        sut3("dolor")
        sut3(FooBar.qux)

        sut2(2)
        sut2("ipsum")
        sut2(FooBar.bar)

        sut1(1)
        sut1("lorem")
        sut1(FooBar.foo)

        #expect(spy3.records.count == 1)
        #expect(spy3.records[0] as? FooBar == .qux)

        #expect(spy2.records.count == 2)
        #expect(spy2.records[0] as? Int == 3)
        #expect(spy2.records[1] as? Int == 2)

        #expect(spy1.records.count == 6)
        #expect(spy1.records[0] as? String == "dolor")
        #expect(spy1.records[1] as? String == "ipsum")
        #expect(spy1.records[2] as? FooBar == .bar)
        #expect(spy1.records[3] as? Int == 1)
        #expect(spy1.records[4] as? String == "lorem")
        #expect(spy1.records[5] as? FooBar == .foo)
    }
}

private enum FooBar {
    case foo
    case bar
    case qux
}
