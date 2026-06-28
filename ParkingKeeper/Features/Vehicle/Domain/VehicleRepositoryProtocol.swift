import Foundation

protocol VehicleRepositoryProtocol {
    func fetchAll() async throws -> [Vehicle]
    func fetch(by entityID: UUID) async throws -> Vehicle?
    func fetchByClient(_ clientID: UUID) async throws -> [Vehicle]
    func create(_ vehicle: Vehicle) async throws
    func update(_ vehicle: Vehicle) async throws
    func delete(entityID: UUID) async throws
}
