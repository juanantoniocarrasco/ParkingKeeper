import Foundation
import SwiftData

@Model
final class SpotModel {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var number: Int
    var status: SpotStatusModel

    @Relationship(deleteRule: .nullify, inverse: \AssignmentModel.spot)
    var assignments: [AssignmentModel] = []

    init(
        id: UUID = UUID(),
        number: Int,
        status: SpotStatusModel = .free
    ) {
        self.id = id
        self.number = number
        self.status = status
    }
}

enum SpotStatusModel: String, Codable {
    case free
    case occupied
}
