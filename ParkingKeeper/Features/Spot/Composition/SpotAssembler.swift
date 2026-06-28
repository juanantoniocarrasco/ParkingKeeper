import SwiftData

enum SpotAssembler {
    static func assemble(modelContext: ModelContext) -> SpotLogic {
        let repository = SpotRepository(modelContext: modelContext)
        return SpotLogic(repository: repository)
    }
}
