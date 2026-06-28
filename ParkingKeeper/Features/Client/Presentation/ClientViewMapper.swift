import Foundation

enum ClientViewMapper {
    static func toDetailModel(_ client: Client) -> ClientDetailView.Model {
        ClientDetailView.Model(
            id: client.id,
            name: client.name,
            phone: client.phone,
            email: client.email,
            notes: client.notes
        )
    }

    static func toFormModel(_ client: Client?) -> ClientFormView.Model? {
        guard let client else {
            return ClientFormView.mockNew()
        }
        return ClientFormView.Model(
            id: client.id,
            name: client.name,
            phone: client.phone,
            email: client.email,
            notes: client.notes
        )
    }
}
