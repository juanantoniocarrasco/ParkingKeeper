import Foundation
import SwiftData

final class AssignmentRepository: AssignmentRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Assignment] {
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        let models = try modelContext.fetch(descriptor)
        return models.map(AssignmentDataMapper.toEntity)
    }

    func fetch(by entityID: UUID) async throws -> Assignment? {
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        return models.first.map(AssignmentDataMapper.toEntity)
    }

    func fetchActive() async throws -> [Assignment] {
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        let models = try modelContext.fetch(descriptor)
        return models.filter { $0.endDate == nil }.map(AssignmentDataMapper.toEntity)
    }

    func fetchBySpot(_ spotID: UUID) async throws -> [Assignment] {
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(
            predicate: #Predicate { $0.spot?.id == spotID },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map(AssignmentDataMapper.toEntity)
    }

    func create(_ assignment: Assignment) async throws {
        let model = AssignmentDataMapper.toModel(assignment, in: modelContext)
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(_ assignment: Assignment) async throws {
        let entityID = assignment.id
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        guard let model = models.first else { return }
        AssignmentDataMapper.applyEntity(assignment, to: model, in: modelContext)
        try modelContext.save()
    }

    func delete(entityID: UUID) async throws {
        let descriptor = FetchDescriptor<AssignmentPersistentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
