import SwiftData

enum ClientAssembler {
    static func assemble(modelContext: ModelContext) -> ClientLogic {
        let repository = ClientRepository(modelContext: modelContext)
        return ClientLogic(repository: repository)
    }
}
