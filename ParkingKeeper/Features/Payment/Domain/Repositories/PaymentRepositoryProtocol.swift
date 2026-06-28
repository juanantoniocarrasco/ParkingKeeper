import Foundation

protocol PaymentRepositoryProtocol {
    func fetchAll() async throws -> [Payment]
    func fetch(by entityID: UUID) async throws -> Payment?
    func fetchByAssignment(_ assignmentID: UUID) async throws -> [Payment]
    func create(_ payment: Payment) async throws
    func update(_ payment: Payment) async throws
    func delete(entityID: UUID) async throws
}
