import Foundation
import SwiftData

final class PaymentRepository: PaymentRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Payment] {
        let descriptor = FetchDescriptor<PaymentModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        let models = try modelContext.fetch(descriptor)
        return models.map(PaymentMapper.toEntity)
    }

    func fetch(by entityID: UUID) async throws -> Payment? {
        let descriptor = FetchDescriptor<PaymentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        return models.first.map(PaymentMapper.toEntity)
    }

    func fetchByAssignment(_ assignmentID: UUID) async throws -> [Payment] {
        let descriptor = FetchDescriptor<PaymentModel>(
            predicate: #Predicate { $0.assignment?.id == assignmentID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map(PaymentMapper.toEntity)
    }

    func create(_ payment: Payment) async throws {
        let model = PaymentMapper.toModel(payment, in: modelContext)
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(_ payment: Payment) async throws {
        let entityID = payment.id
        let descriptor = FetchDescriptor<PaymentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        guard let model = models.first else { return }
        PaymentMapper.applyEntity(payment, to: model, in: modelContext)
        try modelContext.save()
    }

    func delete(entityID: UUID) async throws {
        let descriptor = FetchDescriptor<PaymentModel>(predicate: #Predicate { $0.id == entityID })
        let models = try modelContext.fetch(descriptor)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
