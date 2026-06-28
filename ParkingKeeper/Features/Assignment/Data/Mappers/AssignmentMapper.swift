import Foundation
import SwiftData

enum AssignmentMapper {
    static func toEntity(_ model: AssignmentModel) -> Assignment {
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

    static func toModel(_ entity: Assignment, in context: ModelContext) -> AssignmentModel {
        let model = AssignmentModel(
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

    static func applyEntity(_ entity: Assignment, to model: AssignmentModel, in context: ModelContext) {
        model.startDate = entity.startDate
        model.endDate = entity.endDate
        model.monthlyRate = entity.monthlyRate
        model.client = clientModel(by: entity.clientID, in: context)
        model.vehicle = vehicleModel(by: entity.vehicleID, in: context)
        model.spot = spotModel(by: entity.spotID, in: context)
    }

    private static func clientModel(by modelID: UUID, in context: ModelContext) -> ClientModel? {
        var descriptor = FetchDescriptor<ClientModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func vehicleModel(by modelID: UUID, in context: ModelContext) -> VehicleModel? {
        var descriptor = FetchDescriptor<VehicleModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func spotModel(by modelID: UUID, in context: ModelContext) -> SpotModel? {
        var descriptor = FetchDescriptor<SpotModel>(predicate: #Predicate { $0.id == modelID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }
}
