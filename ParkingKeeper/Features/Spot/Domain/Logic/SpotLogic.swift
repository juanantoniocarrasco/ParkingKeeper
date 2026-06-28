import Foundation

struct SpotLogic {
    private let repository: SpotRepositoryProtocol

    init(repository: SpotRepositoryProtocol) {
        self.repository = repository
    }
}
