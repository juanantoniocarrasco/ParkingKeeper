import Foundation
import SwiftData

@Model
final class VehiclePersistentModel {
    @Attribute(.unique) var id: UUID
    var licensePlate: String
    var brand: String?
    var model: String?

    var client: ClientPersistentModel?

    @Relationship(deleteRule: .nullify, inverse: \AssignmentPersistentModel.vehicle)
    var assignments: [AssignmentPersistentModel] = []

    init(
        id: UUID = UUID(),
        licensePlate: String,
        brand: String? = nil,
        model: String? = nil
    ) {
        self.id = id
        self.licensePlate = licensePlate
        self.brand = brand
        self.model = model
    }
}
