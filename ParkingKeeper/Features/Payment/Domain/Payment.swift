import Foundation

struct Payment: Identifiable, Hashable {
    let id: UUID
    let assignmentID: UUID
    let amount: Double
    let method: PaymentMethod
    let date: Date
    let periodMonths: Int
    let periodStartDate: Date
    let periodEndDate: Date

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

    func updated(
        assignmentID: UUID? = nil,
        amount: Double? = nil,
        method: PaymentMethod? = nil,
        date: Date? = nil,
        periodMonths: Int? = nil,
        periodStartDate: Date? = nil,
        periodEndDate: Date? = nil
    ) -> Payment {
        Payment(
            id: id,
            assignmentID: assignmentID ?? self.assignmentID,
            amount: amount ?? self.amount,
            method: method ?? self.method,
            date: date ?? self.date,
            periodMonths: periodMonths ?? self.periodMonths,
            periodStartDate: periodStartDate ?? self.periodStartDate,
            periodEndDate: periodEndDate ?? self.periodEndDate
        )
    }
}

enum PaymentMethod: String, Codable {
    case cash
    case bizum
}
