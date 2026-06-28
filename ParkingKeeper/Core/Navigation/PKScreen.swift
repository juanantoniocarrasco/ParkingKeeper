import Foundation

enum PKScreen: Hashable {
    case dashboard
    case clientList
    case clientDetail(Client)
    case clientForm(Client?)
    case vehicleList
    case vehicleForm(Vehicle?)
    case spotGrid
    case assignmentList
    case assignmentDetail(Assignment)
    case assignmentForm(Assignment?)
    case paymentList
    case paymentForm(Payment?)
    case annualGrid

    var icon: String {
        switch self {
        case .dashboard: return "rectangle.grid.1x2"
        case .clientList, .clientDetail, .clientForm: return "person.2"
        case .vehicleList, .vehicleForm: return "car"
        case .spotGrid: return "parkingsign"
        case .assignmentList, .assignmentDetail, .assignmentForm: return "arrow.triangle.swap"
        case .paymentList, .paymentForm: return "creditcard"
        case .annualGrid: return "tablecells"
        }
    }
}
