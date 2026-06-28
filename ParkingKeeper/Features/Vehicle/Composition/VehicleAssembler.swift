import SwiftData

enum VehicleAssembler {
    static func assemble(modelContext: ModelContext) -> VehicleLogic {
        let repository = VehicleRepository(modelContext: modelContext)
        return VehicleLogic(repository: repository)
    }
}
