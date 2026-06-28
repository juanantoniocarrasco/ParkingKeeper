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

extension Spot {
    static let mockSpot1 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000001")!, number: 1)
    static let mockSpot2 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000002")!, number: 2, status: .occupied)
    static let mockSpot3 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000003")!, number: 3)
    static let mockSpot4 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000004")!, number: 4, status: .occupied)
    static let mockSpot5 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000005")!, number: 5)
    static let mockSpot6 = Spot(id: UUID(uuidString: "00000000-0000-0000-0002-000000000006")!, number: 6)
}
