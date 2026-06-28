import Foundation
import SwiftData

@Model
final class SpotPersistentModel {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var number: Int
    var status: SpotStatusPersistentModel

    @Relationship(deleteRule: .nullify, inverse: \AssignmentPersistentModel.spot)
    var assignments: [AssignmentPersistentModel] = []

    init(
        id: UUID = UUID(),
        number: Int,
        status: SpotStatusPersistentModel = .free
    ) {
        self.id = id
        self.number = number
        self.status = status
    }
}

enum SpotStatusPersistentModel: String, Codable {
    case free
    case occupied
}
