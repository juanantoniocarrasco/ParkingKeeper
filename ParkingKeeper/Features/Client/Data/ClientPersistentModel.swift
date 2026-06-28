import Foundation
import SwiftData

@Model
final class ClientPersistentModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var phone: String?
    var email: String?
    var notes: String?

    @Relationship(deleteRule: .cascade, inverse: \VehiclePersistentModel.client)
    var vehicles: [VehiclePersistentModel] = []

    @Relationship(deleteRule: .nullify, inverse: \AssignmentPersistentModel.client)
    var assignments: [AssignmentPersistentModel] = []

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
