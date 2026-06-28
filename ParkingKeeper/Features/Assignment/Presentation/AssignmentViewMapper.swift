import Foundation

enum AssignmentViewMapper {
    static func toFormModel(_ assignment: Assignment?) -> AssignmentFormView.Model? {
        guard let assignment else {
            return AssignmentFormView.mockNew()
        }
        return AssignmentFormView.Model(
            id: assignment.id,
            clientID: assignment.clientID,
            vehicleID: assignment.vehicleID,
            spotID: assignment.spotID,
            startDate: assignment.startDate,
            monthlyRate: assignment.monthlyRate
        )
    }
}
