import Foundation
import SwiftData

final class SpotRepository: SpotRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Spot] {
        let descriptor = FetchDescriptor<SpotModel>(sortBy: [SortDescriptor(\.number)])
        let models = try modelContext.fetch(descriptor)
        return models.map(SpotMapper.toEntity)
    }

    func fetch(by entityID: UUID) async throws -> Spot? {
        let descriptor = FetchDescriptor<SpotModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        return models.first.map(SpotMapper.toEntity)
    }

    func fetchFreeSpots() async throws -> [Spot] {
        let descriptor = FetchDescriptor<SpotModel>(sortBy: [SortDescriptor(\.number)])
        let models = try modelContext.fetch(descriptor)
        return models.filter { $0.status == .free }.map(SpotMapper.toEntity)
    }

    func create(_ spot: Spot) async throws {
        let model = SpotMapper.toModel(spot)
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(_ spot: Spot) async throws {
        let entityID = spot.id
        let descriptor = FetchDescriptor<SpotModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        guard let model = models.first else { return }
        SpotMapper.applyEntity(spot, to: model)
        try modelContext.save()
    }

    func delete(entityID: UUID) async throws {
        let descriptor = FetchDescriptor<SpotModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
