import Foundation
import SwiftData

enum AssignmentDataMapper {
    static func toEntity(_ model: AssignmentPersistentModel) -> Assignment {
        Assignment(
            id: model.id,
            clientID: model.client?.id ?? UUID(),
            vehicleID: model.vehicle?.id ?? UUID(),
            spotID: model.spot?.id ?? UUID(),
            startDate: model.startDate,
            endDate: model.endDate,
            monthlyRate: model.monthlyRate
        )
    }

    static func toModel(_ entity: Assignment, in context: ModelContext) -> AssignmentPersistentModel {
        let model = AssignmentPersistentModel(
            id: entity.id,
            startDate: entity.startDate,
            endDate: entity.endDate,
            monthlyRate: entity.monthlyRate
        )
        model.client = clientModel(by: entity.clientID, in: context)
        model.vehicle = vehicleModel(by: entity.vehicleID, in: context)
        model.spot = spotModel(by: entity.spotID, in: context)
        return model
    }

    static func applyEntity(_ entity: Assignment, to model: AssignmentPersistentModel, in context: ModelContext) {
        model.startDate = entity.startDate
        model.endDate = entity.endDate
        model.monthlyRate = entity.monthlyRate
        model.client = clientModel(by: entity.clientID, in: context)
        model.vehicle = vehicleModel(by: entity.vehicleID, in: context)
        model.spot = spotModel(by: entity.spotID, in: context)
    }

    private static func clientModel(by modelID: UUID, in context: ModelContext) -> ClientPersistentModel? {
        var descriptor = FetchDescriptor<ClientPersistentModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func vehicleModel(by modelID: UUID, in context: ModelContext) -> VehiclePersistentModel? {
        var descriptor = FetchDescriptor<VehiclePersistentModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func spotModel(by modelID: UUID, in context: ModelContext) -> SpotPersistentModel? {
        var descriptor = FetchDescriptor<SpotPersistentModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }
}
