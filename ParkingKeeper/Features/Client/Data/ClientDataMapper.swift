import Foundation

enum ClientDataMapper {
    static func toEntity(_ model: ClientPersistentModel) -> Client {
        Client(
            id: model.id,
            name: model.name,
            phone: model.phone,
            email: model.email,
            notes: model.notes,
            vehicleIDs: model.vehicles.map(\.id)
        )
    }

    static func toModel(_ entity: Client) -> ClientPersistentModel {
        ClientPersistentModel(
            id: entity.id,
            name: entity.name,
            phone: entity.phone,
            email: entity.email,
            notes: entity.notes
        )
    }

    static func applyEntity(_ entity: Client, to model: ClientPersistentModel) {
        model.name = entity.name
        model.phone = entity.phone
        model.email = entity.email
        model.notes = entity.notes
    }
}
