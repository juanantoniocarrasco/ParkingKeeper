import Foundation

struct Payment: Identifiable, Hashable {
    let id: UUID
    var assignmentID: UUID
    var amount: Double
    var method: PaymentMethod
    var date: Date
    var periodMonths: Int
    var periodStartDate: Date
    var periodEndDate: Date

    init(
        id: UUID = UUID(),
        assignmentID: UUID,
        amount: Double,
        method: PaymentMethod,
        date: Date,
        periodMonths: Int,
        periodStartDate: Date,
        periodEndDate: Date
    ) {
        self.id = id
        self.assignmentID = assignmentID
        self.amount = amount
        self.method = method
        self.date = date
        self.periodMonths = periodMonths
        self.periodStartDate = periodStartDate
        self.periodEndDate = periodEndDate
    }
}

enum PaymentMethod: String, Codable {
    case cash
    case bizum
}
