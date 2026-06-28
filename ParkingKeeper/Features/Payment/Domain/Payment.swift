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

extension Payment {
    static let mockJanuary = Payment(
        id: UUID(uuidString: "00000000-0000-0000-0004-000000000001")!,
        assignmentID: Assignment.mockActive.id,
        amount: 75.0,
        method: .bizum,
        date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))!,
        periodMonths: 1,
        periodStartDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 1))!,
        periodEndDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 31))!
    )

    static let mockFebruary = Payment(
        id: UUID(uuidString: "00000000-0000-0000-0004-000000000002")!,
        assignmentID: Assignment.mockActive.id,
        amount: 75.0,
        method: .cash,
        date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))!,
        periodMonths: 1,
        periodStartDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 1))!,
        periodEndDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 28))!
    )
}
