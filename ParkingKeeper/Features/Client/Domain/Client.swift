import Foundation

struct Client: Identifiable, Hashable {
    let id: UUID
    let name: String
    let phone: String?
    let email: String?
    let notes: String?
    let vehicleIDs: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        notes: String? = nil,
        vehicleIDs: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.notes = notes
        self.vehicleIDs = vehicleIDs
    }

    func updated(
        name: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        notes: String? = nil,
        vehicleIDs: [UUID]? = nil
    ) -> Client {
        Client(
            id: id,
            name: name ?? self.name,
            phone: phone ?? self.phone,
            email: email ?? self.email,
            notes: notes ?? self.notes,
            vehicleIDs: vehicleIDs ?? self.vehicleIDs
        )
    }
}

extension Client {
    static let mockMaria = Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Maria Garcia",
        phone: "612345678",
        email: "maria@example.com",
        notes: "Prefiere pago por bizum"
    )

    static let mockCarlos = Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        name: "Carlos Lopez",
        phone: "698765432",
        email: "carlos@example.com"
    )

    static let mockAna = Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
        name: "Ana Martinez",
        phone: "655123789",
        notes: "Plaza 3 fija desde 2024"
    )
}
