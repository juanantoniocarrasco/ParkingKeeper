import Foundation

protocol AssignmentRepositoryProtocol {
    func fetchAll() async throws -> [Assignment]
    func fetch(by entityID: UUID) async throws -> Assignment?
    func fetchActive() async throws -> [Assignment]
    func fetchBySpot(_ spotID: UUID) async throws -> [Assignment]
    func create(_ assignment: Assignment) async throws
    func update(_ assignment: Assignment) async throws
    func delete(entityID: UUID) async throws
}
