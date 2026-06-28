import Foundation

struct Client: Identifiable, Hashable {
    let id: UUID
    var name: String
    var phone: String?
    var email: String?
    var notes: String?
    var vehicleIDs: [UUID]

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
}
