import SwiftData

enum AssignmentAssembler {
    static func assemble(modelContext: ModelContext) -> AssignmentLogic {
        let repository = AssignmentRepository(modelContext: modelContext)
        return AssignmentLogic(repository: repository)
    }
}
