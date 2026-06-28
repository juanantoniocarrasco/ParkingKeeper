import Foundation
import SwiftData

@Model
final class VehicleModel {
    @Attribute(.unique) var id: UUID
    var licensePlate: String
    var brand: String?
    var model: String?

    var client: ClientModel?

    @Relationship(deleteRule: .nullify, inverse: \AssignmentModel.vehicle)
    var assignments: [AssignmentModel] = []

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
