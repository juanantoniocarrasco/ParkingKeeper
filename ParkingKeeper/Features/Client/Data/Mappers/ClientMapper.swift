import Foundation

enum ClientMapper {
    static func toEntity(_ model: ClientModel) -> Client {
        Client(
            id: model.id,
            name: model.name,
            phone: model.phone,
            email: model.email,
            notes: model.notes,
            vehicleIDs: model.vehicles.map(\.id)
        )
    }

    static func toModel(_ entity: Client) -> ClientModel {
        ClientModel(
            id: entity.id,
            name: entity.name,
            phone: entity.phone,
            email: entity.email,
            notes: entity.notes
        )
    }

    static func applyEntity(_ entity: Client, to model: ClientModel) {
        model.name = entity.name
        model.phone = entity.phone
        model.email = entity.email
        model.notes = entity.notes
    }
}
