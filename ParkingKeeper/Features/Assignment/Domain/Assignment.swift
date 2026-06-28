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

extension Assignment {
    static let mockActive = Assignment(
        id: UUID(uuidString: "00000000-0000-0000-0003-000000000001")!,
        clientID: Client.mockMaria.id,
        vehicleID: Vehicle.mockSeatLeon.id,
        spotID: Spot.mockSpot2.id,
        startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 1))!,
        monthlyRate: 75.0
    )

    static let mockHistoric = Assignment(
        id: UUID(uuidString: "00000000-0000-0000-0003-000000000002")!,
        clientID: Client.mockCarlos.id,
        vehicleID: Vehicle.mockToyota.id,
        spotID: Spot.mockSpot4.id,
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 1))!,
        endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!,
        monthlyRate: 80.0
    )
}
