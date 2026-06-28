import Foundation
import SwiftData

final class VehicleRepository: VehicleRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Vehicle] {
        let descriptor = FetchDescriptor<VehicleModel>(sortBy: [SortDescriptor(\.licensePlate)])
        let models = try modelContext.fetch(descriptor)
        return models.map(VehicleMapper.toEntity)
    }

    func fetch(by entityID: UUID) async throws -> Vehicle? {
        let descriptor = FetchDescriptor<VehicleModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        return models.first.map(VehicleMapper.toEntity)
    }

    func fetchByClient(_ clientID: UUID) async throws -> [Vehicle] {
        let descriptor = FetchDescriptor<VehicleModel>(
            predicate: #Predicate { $0.client?.id == clientID },
            sortBy: [SortDescriptor(\.licensePlate)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map(VehicleMapper.toEntity)
    }

    func create(_ vehicle: Vehicle) async throws {
        let model = VehicleMapper.toModel(vehicle, in: modelContext)
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(_ vehicle: Vehicle) async throws {
        let entityID = vehicle.id
        let descriptor = FetchDescriptor<VehicleModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        guard let model = models.first else { return }
        VehicleMapper.applyEntity(vehicle, to: model, in: modelContext)
        try modelContext.save()
    }

    func delete(entityID: UUID) async throws {
        let descriptor = FetchDescriptor<VehicleModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
