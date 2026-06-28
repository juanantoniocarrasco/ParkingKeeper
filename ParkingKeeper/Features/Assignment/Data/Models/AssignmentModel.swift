import Foundation
import SwiftData

@Model
final class AssignmentModel {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date?
    var monthlyRate: Double

    var client: ClientModel?
    var vehicle: VehicleModel?
    var spot: SpotModel?

    @Relationship(deleteRule: .cascade, inverse: \PaymentModel.assignment)
    var payments: [PaymentModel] = []

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
