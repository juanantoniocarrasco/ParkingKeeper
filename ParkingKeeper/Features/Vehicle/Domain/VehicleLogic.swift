import Foundation

struct VehicleLogic {
    private let repository: VehicleRepositoryProtocol

    init(repository: VehicleRepositoryProtocol) {
        self.repository = repository
    }
}
