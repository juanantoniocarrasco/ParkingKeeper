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
