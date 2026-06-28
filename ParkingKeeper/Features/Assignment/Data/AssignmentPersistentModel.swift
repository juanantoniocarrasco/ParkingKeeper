import Foundation
import SwiftData

@Model
final class AssignmentPersistentModel {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date?
    var monthlyRate: Double

    var client: ClientPersistentModel?
    var vehicle: VehiclePersistentModel?
    var spot: SpotPersistentModel?

    @Relationship(deleteRule: .cascade, inverse: \PaymentPersistentModel.assignment)
    var payments: [PaymentPersistentModel] = []

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil,
        monthlyRate: Double
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.monthlyRate = monthlyRate
    }
}
