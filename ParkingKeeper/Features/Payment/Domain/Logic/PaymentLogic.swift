import Foundation

struct PaymentLogic {
    private let repository: PaymentRepositoryProtocol

    init(repository: PaymentRepositoryProtocol) {
        self.repository = repository
    }
}
