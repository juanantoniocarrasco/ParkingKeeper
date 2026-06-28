import Foundation

struct ClientLogic {
    private let repository: ClientRepositoryProtocol

    init(repository: ClientRepositoryProtocol) {
        self.repository = repository
    }
}
