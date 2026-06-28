import Foundation
import SwiftData

@Model
final class PaymentPersistentModel {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var method: PaymentMethodPersistentModel
    var date: Date
    var periodMonths: Int
    var periodStartDate: Date
    var periodEndDate: Date

    var assignment: AssignmentPersistentModel?

    init(
        id: UUID = UUID(),
        amount: Double,
        method: PaymentMethodPersistentModel,
        date: Date,
        periodMonths: Int,
        periodStartDate: Date,
        periodEndDate: Date
    ) {
        self.id = id
        self.amount = amount
        self.method = method
        self.date = date
        self.periodMonths = periodMonths
        self.periodStartDate = periodStartDate
        self.periodEndDate = periodEndDate
    }
}

enum PaymentMethodPersistentModel: String, Codable {
    case cash
    case bizum
}
