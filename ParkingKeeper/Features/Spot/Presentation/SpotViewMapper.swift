import Foundation

enum SpotViewMapper {
    static func toGridItems(_ spots: [Spot]) -> [SpotGridView.SpotItem] {
        spots.map { spot in
            SpotGridView.SpotItem(
                id: spot.id,
                number: spot.number,
                status: spot.status == .free ? .free : .occupied
            )
        }
    }
}
