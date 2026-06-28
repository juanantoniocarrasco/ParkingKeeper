import Foundation

enum SpotDataMapper {
    static func toEntity(_ model: SpotPersistentModel) -> Spot {
        Spot(
            id: model.id,
            number: model.number,
            status: SpotDataMapper.mapStatus(from: model.status)
        )
    }

    static func toModel(_ entity: Spot) -> SpotPersistentModel {
        SpotPersistentModel(
            id: entity.id,
            number: entity.number,
            status: SpotDataMapper.mapStatus(from: entity.status)
        )
    }

    static func applyEntity(_ entity: Spot, to model: SpotPersistentModel) {
        model.number = entity.number
        model.status = SpotDataMapper.mapStatus(from: entity.status)
    }

    private static func mapStatus(from status: SpotStatus) -> SpotStatusPersistentModel {
        switch status {
        case .free: return .free
        case .occupied: return .occupied
        }
    }

    private static func mapStatus(from status: SpotStatusPersistentModel) -> SpotStatus {
        switch status {
        case .free: return .free
        case .occupied: return .occupied
        }
    }
}
