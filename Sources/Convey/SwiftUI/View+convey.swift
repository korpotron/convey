import SwiftUI

public extension View {
    func convey(_ handler: ConveyHandler) -> some View {
        transformEnvironment(\.convey) { action in
            action = action.chaining(handler)
        }
    }

    func convey<T>(of _: T.Type, block: @escaping (_ value: T) -> Void) -> some View {
        convey(.done(block))
    }

    func convey<A, B>(map _: A.Type, mapper: @escaping (A) -> B) -> some View {
        convey(.map(mapper))
    }

    func convey<T>(assign binding: Binding<T?>) -> some View {
        convey(of: T.self) { value in
            binding.wrappedValue = value
        }
    }

    func convey<T>(of _: T.Type, append binding: Binding<[T]>) -> some View {
        convey(of: T.self) { value in
            binding.wrappedValue += [value]
        }
    }

    func convey<T: Hashable>(of _: T, append binding: Binding<NavigationPath>) -> some View {
        convey(of: T.self) { value in
            binding.wrappedValue.append(value)
        }
    }
}
