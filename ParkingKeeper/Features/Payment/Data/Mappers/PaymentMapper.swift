import Foundation
import SwiftData

enum PaymentMapper {
    static func toEntity(_ model: PaymentModel) -> Payment {
        Payment(
            id: model.id,
            assignmentID: model.assignment?.id ?? UUID(),
            amount: model.amount,
            method: PaymentMapper.mapMethod(from: model.method),
            date: model.date,
            periodMonths: model.periodMonths,
            periodStartDate: model.periodStartDate,
            periodEndDate: model.periodEndDate
        )
    }

    static func toModel(_ entity: Payment, in context: ModelContext) -> PaymentModel {
        let model = PaymentModel(
            id: entity.id,
            amount: entity.amount,
            method: PaymentMapper.mapMethod(from: entity.method),
            date: entity.date,
            periodMonths: entity.periodMonths,
            periodStartDate: entity.periodStartDate,
            periodEndDate: entity.periodEndDate
        )
        let assignmentID = entity.assignmentID
        var descriptor = FetchDescriptor<AssignmentModel>(predicate: #Predicate { $0.id == assignmentID })
        descriptor.fetchLimit = 1
        model.assignment = try? context.fetch(descriptor).first
        return model
    }

    static func applyEntity(_ entity: Payment, to model: PaymentModel, in context: ModelContext) {
        model.amount = entity.amount
        model.method = PaymentMapper.mapMethod(from: entity.method)
        model.date = entity.date
        model.periodMonths = entity.periodMonths
        model.periodStartDate = entity.periodStartDate
        model.periodEndDate = entity.periodEndDate
        let assignmentID = entity.assignmentID
        var descriptor = FetchDescriptor<AssignmentModel>(predicate: #Predicate { $0.id == assignmentID })
        descriptor.fetchLimit = 1
        model.assignment = try? context.fetch(descriptor).first
    }

    private static func mapMethod(from method: PaymentMethod) -> PaymentMethodModel {
        switch method {
        case .cash: return .cash
        case .bizum: return .bizum
        }
    }

    private static func mapMethod(from method: PaymentMethodModel) -> PaymentMethod {
        switch method {
        case .cash: return .cash
        case .bizum: return .bizum
        }
    }
}
