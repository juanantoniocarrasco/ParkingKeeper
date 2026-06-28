import Foundation

struct Assignment: Identifiable, Hashable {
    let id: UUID
    var clientID: UUID
    var vehicleID: UUID
    var spotID: UUID
    var startDate: Date
    var endDate: Date?
    var monthlyRate: Double

    init(
        id: UUID = UUID(),
        clientID: UUID,
        vehicleID: UUID,
        spotID: UUID,
        startDate: Date,
        endDate: Date? = nil,
        monthlyRate: Double
    ) {
        self.id = id
        self.clientID = clientID
        self.vehicleID = vehicleID
        self.spotID = spotID
        self.startDate = startDate
        self.endDate = endDate
        self.monthlyRate = monthlyRate
    }
}
