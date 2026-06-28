import Foundation

enum VehicleViewMapper {
    static func toFormModel(_ vehicle: Vehicle?) -> VehicleFormView.Model? {
        guard let vehicle else {
            return VehicleFormView.mockNew()
        }
        return VehicleFormView.Model(
            id: vehicle.id,
            licensePlate: vehicle.licensePlate,
            brand: vehicle.brand,
            model: vehicle.model
        )
    }
}
