import Foundation

struct Assignment: Identifiable, Hashable {
    let id: UUID
    let clientID: UUID
    let vehicleID: UUID
    let spotID: UUID
    let startDate: Date
    let endDate: Date?
    let monthlyRate: Double

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

    func updated(
        clientID: UUID? = nil,
        vehicleID: UUID? = nil,
        spotID: UUID? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        monthlyRate: Double? = nil
    ) -> Assignment {
        Assignment(
            id: id,
            clientID: clientID ?? self.clientID,
            vehicleID: vehicleID ?? self.vehicleID,
            spotID: spotID ?? self.spotID,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            monthlyRate: monthlyRate ?? self.monthlyRate
        )
    }
}
