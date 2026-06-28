import Foundation
import SwiftData

@Model
final class ClientModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var phone: String?
    var email: String?
    var notes: String?

    @Relationship(deleteRule: .cascade, inverse: \VehicleModel.client)
    var vehicles: [VehicleModel] = []

    @Relationship(deleteRule: .nullify, inverse: \AssignmentModel.client)
    var assignments: [AssignmentModel] = []

    init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.notes = notes
    }
}
