import Foundation

struct Spot: Identifiable, Hashable {
    let id: UUID
    var number: Int
    var status: SpotStatus

    init(
        id: UUID = UUID(),
        number: Int,
        status: SpotStatus = .free
    ) {
        self.id = id
        self.number = number
        self.status = status
    }
}

enum SpotStatus: String, Codable {
    case free
    case occupied
}
