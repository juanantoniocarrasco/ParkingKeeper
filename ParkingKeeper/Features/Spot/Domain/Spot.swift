import Foundation

struct Spot: Identifiable, Hashable {
    let id: UUID
    let number: Int
    let status: SpotStatus

    init(
        id: UUID = UUID(),
        number: Int,
        status: SpotStatus = .free
    ) {
        self.id = id
        self.number = number
        self.status = status
    }

    func updated(
        number: Int? = nil,
        status: SpotStatus? = nil
    ) -> Spot {
        Spot(
            id: id,
            number: number ?? self.number,
            status: status ?? self.status
        )
    }
}

enum SpotStatus: String, Codable {
    case free
    case occupied
}
