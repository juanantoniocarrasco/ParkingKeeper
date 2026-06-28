import Foundation

struct AssignmentLogic {
    private let repository: AssignmentRepositoryProtocol

    init(repository: AssignmentRepositoryProtocol) {
        self.repository = repository
    }
}
