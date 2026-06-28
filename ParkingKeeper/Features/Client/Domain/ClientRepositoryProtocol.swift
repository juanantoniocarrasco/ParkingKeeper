import Foundation

protocol ClientRepositoryProtocol {
    func fetchAll() async throws -> [Client]
    func fetch(by entityID: UUID) async throws -> Client?
    func create(_ client: Client) async throws
    func update(_ client: Client) async throws
    func delete(entityID: UUID) async throws
}
