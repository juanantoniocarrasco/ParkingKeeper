import SwiftData

enum PaymentAssembler {
    static func assemble(modelContext: ModelContext) -> PaymentLogic {
        let repository = PaymentRepository(modelContext: modelContext)
        return PaymentLogic(repository: repository)
    }
}
