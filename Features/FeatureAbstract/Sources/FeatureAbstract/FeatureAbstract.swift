import Combine
import Foundation

public struct ServiceError: Error {
    public let underlyingError: Error
    public let code: Int

    public init(underlyingError: Error, code: Int) {
        self.underlyingError = underlyingError
        self.code = code
    }
}

public protocol Networking {
    func send(request: URLRequest) -> AnyPublisher<Data?, ServiceError>
}
