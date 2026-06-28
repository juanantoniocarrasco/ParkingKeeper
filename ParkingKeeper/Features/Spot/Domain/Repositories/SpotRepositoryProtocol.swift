import Foundation

protocol SpotRepositoryProtocol {
    func fetchAll() async throws -> [Spot]
    func fetch(by entityID: UUID) async throws -> Spot?
    func fetchFreeSpots() async throws -> [Spot]
    func create(_ spot: Spot) async throws
    func update(_ spot: Spot) async throws
    func delete(entityID: UUID) async throws
}
