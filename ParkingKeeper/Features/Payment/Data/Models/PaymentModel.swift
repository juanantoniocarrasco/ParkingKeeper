import Foundation
import SwiftData

@Model
final class PaymentModel {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var method: PaymentMethodModel
    var date: Date
    var periodMonths: Int
    var periodStartDate: Date
    var periodEndDate: Date

    var assignment: AssignmentModel?

    init(
        id: UUID = UUID(),
        amount: Double,
        method: PaymentMethodModel,
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

enum PaymentMethodModel: String, Codable {
    case cash
    case bizum
}
