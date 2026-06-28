import Foundation

struct Vehicle: Identifiable, Hashable {
    let id: UUID
    var licensePlate: String
    var brand: String?
    var model: String?
    var clientID: UUID?

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
}
