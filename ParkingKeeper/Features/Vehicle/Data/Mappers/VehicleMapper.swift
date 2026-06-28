import Foundation
import SwiftData

enum VehicleMapper {
    static func toEntity(_ model: VehicleModel) -> Vehicle {
        Vehicle(
            id: model.id,
            licensePlate: model.licensePlate,
            brand: model.brand,
            model: model.model,
            clientID: model.client?.id
        )
    }

    static func toModel(_ entity: Vehicle, in context: ModelContext) -> VehicleModel {
        let model = VehicleModel(
            id: entity.id,
            licensePlate: entity.licensePlate,
            brand: entity.brand,
            model: entity.model
        )
        if let clientID = entity.clientID {
            var descriptor = FetchDescriptor<ClientModel>(predicate: #Predicate { $0.id == clientID })
            descriptor.fetchLimit = 1
            model.client = try? context.fetch(descriptor).first
        }
        return model
    }

    static func applyEntity(_ entity: Vehicle, to model: VehicleModel, in context: ModelContext) {
        model.licensePlate = entity.licensePlate
        model.brand = entity.brand
        model.model = entity.model
        if let clientID = entity.clientID {
            var descriptor = FetchDescriptor<ClientModel>(predicate: #Predicate { $0.id == clientID })
            descriptor.fetchLimit = 1
            model.client = try? context.fetch(descriptor).first
        } else {
            model.client = nil
        }
    }
}
