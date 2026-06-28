import Foundation

struct Vehicle: Identifiable, Hashable {
    let id: UUID
    let licensePlate: String
    let brand: String?
    let model: String?
    let clientID: UUID?

    init(
        id: UUID = UUID(),
        licensePlate: String,
        brand: String? = nil,
        model: String? = nil,
        clientID: UUID? = nil
    ) {
        self.id = id
        self.licensePlate = licensePlate
        self.brand = brand
        self.model = model
        self.clientID = clientID
    }

    func updated(
        licensePlate: String? = nil,
        brand: String? = nil,
        model: String? = nil,
        clientID: UUID? = nil
    ) -> Vehicle {
        Vehicle(
            id: id,
            licensePlate: licensePlate ?? self.licensePlate,
            brand: brand ?? self.brand,
            model: model ?? self.model,
            clientID: clientID ?? self.clientID
        )
    }
}

extension Vehicle {
    static let mockSeatLeon = Vehicle(
        id: UUID(uuidString: "00000000-0000-0000-0001-000000000001")!,
        licensePlate: "1234ABC",
        brand: "Seat",
        model: "Leon"
    )

    static let mockRenault = Vehicle(
        id: UUID(uuidString: "00000000-0000-0000-0001-000000000002")!,
        licensePlate: "5678DEF",
        brand: "Renault",
        model: "Clio"
    )

    static let mockToyota = Vehicle(
        id: UUID(uuidString: "00000000-0000-0000-0001-000000000003")!,
        licensePlate: "9012GHI",
        brand: "Toyota",
        model: "Corolla"
    )
}
