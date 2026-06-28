import Foundation
import SwiftData

final class ClientRepository: ClientRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Client] {
        let descriptor = FetchDescriptor<ClientPersistentModel>(sortBy: [SortDescriptor(\.name)])
        let models = try modelContext.fetch(descriptor)
        return models.map(ClientDataMapper.toEntity)
    }

    func fetch(by entityID: UUID) async throws -> Client? {
        let descriptor = FetchDescriptor<ClientPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        return models.first.map(ClientDataMapper.toEntity)
    }

    func create(_ client: Client) async throws {
        let model = ClientDataMapper.toModel(client)
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(_ client: Client) async throws {
        let entityID = client.id
        let descriptor = FetchDescriptor<ClientPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        guard let model = models.first else { return }
        ClientDataMapper.applyEntity(client, to: model)
        try modelContext.save()
    }

    func delete(entityID: UUID) async throws {
        let descriptor = FetchDescriptor<ClientPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
