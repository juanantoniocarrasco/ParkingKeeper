import Foundation

enum ClientViewMapper {
    static func toDetailModel(_ client: Client) -> ClientDetailView.Model {
        ClientDetailView.Model(
            name: client.name,
            phone: client.phone,
            email: client.email,
            notes: client.notes
        )
    }
}
