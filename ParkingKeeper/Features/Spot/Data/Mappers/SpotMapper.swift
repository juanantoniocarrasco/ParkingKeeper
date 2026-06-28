import Foundation

enum SpotMapper {
    static func toEntity(_ model: SpotModel) -> Spot {
        Spot(
            id: model.id,
            number: model.number,
            status: SpotMapper.mapStatus(from: model.status)
        )
    }

    static func toModel(_ entity: Spot) -> SpotModel {
        SpotModel(
            id: entity.id,
            number: entity.number,
            status: SpotMapper.mapStatus(from: entity.status)
        )
    }

    static func applyEntity(_ entity: Spot, to model: SpotModel) {
        model.number = entity.number
        model.status = SpotMapper.mapStatus(from: entity.status)
    }

    private static func mapStatus(from status: SpotStatus) -> SpotStatusModel {
        switch status {
        case .free: return .free
        case .occupied: return .occupied
        }
    }

    private static func mapStatus(from status: SpotStatusModel) -> SpotStatus {
        switch status {
        case .free: return .free
        case .occupied: return .occupied
        }
    }
}
