import Foundation
import SwiftData

enum PaymentDataMapper {
    static func toEntity(_ model: PaymentPersistentModel) -> Payment {
        Payment(
            id: model.id,
            assignmentID: model.assignment?.id ?? UUID(),
            amount: model.amount,
            method: PaymentDataMapper.mapMethod(from: model.method),
            date: model.date,
            periodMonths: model.periodMonths,
            periodStartDate: model.periodStartDate,
            periodEndDate: model.periodEndDate
        )
    }

    static func toModel(_ entity: Payment, in context: ModelContext) -> PaymentPersistentModel {
        let model = PaymentPersistentModel(
            id: entity.id,
            amount: entity.amount,
            method: PaymentDataMapper.mapMethod(from: entity.method),
            date: entity.date,
            periodMonths: entity.periodMonths,
            periodStartDate: entity.periodStartDate,
            periodEndDate: entity.periodEndDate
        )
        let assignmentID = entity.assignmentID
        var descriptor = FetchDescriptor<AssignmentPersistentModel>(predicate: #Predicate { $0.id == assignmentID })
        descriptor.fetchLimit = 1
        model.assignment = try? context.fetch(descriptor).first
        return model
    }

    static func applyEntity(_ entity: Payment, to model: PaymentPersistentModel, in context: ModelContext) {
        model.amount = entity.amount
        model.method = PaymentDataMapper.mapMethod(from: entity.method)
        model.date = entity.date
        model.periodMonths = entity.periodMonths
        model.periodStartDate = entity.periodStartDate
        model.periodEndDate = entity.periodEndDate
        let assignmentID = entity.assignmentID
        var descriptor = FetchDescriptor<AssignmentPersistentModel>(predicate: #Predicate { $0.id == assignmentID })
        descriptor.fetchLimit = 1
        model.assignment = try? context.fetch(descriptor).first
    }

    private static func mapMethod(from method: PaymentMethod) -> PaymentMethodPersistentModel {
        switch method {
        case .cash: return .cash
        case .bizum: return .bizum
        }
    }

    private static func mapMethod(from method: PaymentMethodPersistentModel) -> PaymentMethod {
        switch method {
        case .cash: return .cash
        case .bizum: return .bizum
        }
    }
}
