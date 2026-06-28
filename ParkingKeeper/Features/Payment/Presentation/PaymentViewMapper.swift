import Foundation

enum PaymentViewMapper {
    static func toFormModel(_ payment: Payment?) -> PaymentFormView.Model? {
        guard let payment else {
            return PaymentFormView.mockNew()
        }
        return PaymentFormView.Model(
            id: payment.id,
            assignmentID: payment.assignmentID,
            amount: payment.amount,
            method: payment.method,
            date: payment.date,
            periodMonths: payment.periodMonths
        )
    }
}
