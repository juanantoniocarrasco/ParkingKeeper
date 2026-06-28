import Foundation

enum DemoData {

    /// Cambia a `true` para usar datos de demo en toda la app
    /// No hagas commit con esta propiedad a `true`.
    static let isEnabled = true

    // MARK: - Spots (40)

    static let spots: [Spot] = (1...40).map { i in
        Spot(
            id: UUID(),
            number: i,
            status: i <= 28 ? .occupied : .free
        )
    }

    // MARK: - Clients (35)

    static let clients: [Client] = [
        Client(name: "María García López", phone: "612345601", email: "maria.garcia@example.com"),
        Client(name: "Carlos Martínez Ruiz", phone: "612345602", email: "carlos.martinez@example.com"),
        Client(name: "Ana Fernández Sánchez", phone: "612345603", email: "ana.fernandez@example.com"),
        Client(name: "Javier Pérez Gómez", phone: "612345604"),
        Client(name: "Lucía Torres Díaz", phone: "612345605", email: "lucia.torres@example.com"),
        Client(name: "Miguel Ángel Romero", phone: "612345606"),
        Client(name: "Elena Castro Vega", phone: "612345607", email: "elena.castro@example.com"),
        Client(name: "Pablo Núñez Gil", phone: "612345608"),
        Client(name: "Sara Delgado Ortiz", phone: "612345609", email: "sara.delgado@example.com"),
        Client(name: "David Herrera Flores", phone: "612345610"),
        Client(name: "Laura Jiménez Mora", phone: "612345611", email: "laura.jimenez@example.com"),
        Client(name: "Daniel Ruiz Navarro", phone: "612345612"),
        Client(name: "Carmen Molina Soto", phone: "612345613", email: "carmen.molina@example.com"),
        Client(name: "Alejandro Crespo León", phone: "612345614"),
        Client(name: "Isabel Santos Cruz", phone: "612345615"),
        Client(name: "Raúl Domínguez Rey", phone: "612345616", email: "raul.dominguez@example.com"),
        Client(name: "Patricia Vargas Hidalgo", phone: "612345617"),
        Client(name: "Francisco Aguilar Marín", phone: "612345618", email: "francisco.aguilar@example.com"),
        Client(name: "Natalia Cortés Pardo", phone: "612345619"),
        Client(name: "Alberto Campos Rivas", phone: "612345620", email: "alberto.campos@example.com"),
        Client(name: "Marta Esteban Lozano", phone: "612345621"),
        Client(name: "Sergio Prieto Cano", phone: "612345622"),
        Client(name: "Cristina Garrido Serrano", phone: "612345623", email: "cristina.garrido@example.com"),
        Client(name: "Ignacio Ferrer Peña", phone: "612345624"),
        Client(name: "Beatriz Lorenzo Rubio", phone: "612345625", email: "beatriz.lorenzo@example.com"),
        Client(name: "Jorge Ibáñez Medina", phone: "612345626"),
        Client(name: "Rocío Méndez Gallardo", phone: "612345627"),
        Client(name: "Óscar Pastor Montes", phone: "612345628", email: "oscar.pastor@example.com"),
        Client(name: "Andrea Soler Ponce", phone: "612345629"),
        Client(name: "Guillermo Lamas Bravo", phone: "612345630"),
        Client(name: "Nerea Quintero Aranda", phone: "612345631", email: "nerea.quintero@example.com"),
        Client(name: "Hugo Expósito Nieto", phone: "612345632"),
        Client(name: "Clara Bueno Redondo", phone: "612345633", email: "clara.bueno@example.com"),
        Client(name: "Adrián Román Fuentes", phone: "612345634"),
        Client(name: "Paula Casado Millán", phone: "612345635", email: "paula.casado@example.com"),
    ]

    // MARK: - Vehicles (45)

    private static let plates = [
        "1234ABC", "2345BCD", "3456CDE", "4567DEF", "5678EFG", "6789FGH",
        "7890GHI", "8901HIJ", "9012IJK", "0123JKL", "1122KLM", "2233LMN",
        "3344MNO", "4455NOP", "5566OPQ", "6677PQR", "7788QRS", "8899RST",
        "9900STU", "0011TUV", "1212UVW", "2323VWX", "3434WXY", "4545XYZ",
        "5656YZA", "6767ZAB", "7878ABC", "8989BCD", "9090CDE", "0101DEF",
        "1313EFG", "2424FGH", "3535GHI", "4646HIJ", "5757IJK", "6868JKL",
        "7979KLM", "8080LMN", "9191MNO", "0202NOP", "1414OPQ", "2525PQR",
        "3636QRS", "4747RST", "5858STU",
    ]

    private static let brands = [
        "Seat", "Renault", "Toyota", "Volkswagen", "Peugeot", "Ford",
        "Opel", "Citroën", "BMW", "Mercedes", "Audi", "Hyundai",
        "Kia", "Nissan", "Dacia", "Fiat", "Skoda", "Mazda",
        "Honda", "Volvo", "Mini", "Jeep",
    ]

    private static let models = [
        "León", "Clio", "Corolla", "Golf", "308", "Focus",
        "Corsa", "C3", "Serie 1", "Clase A", "A3", "Tucson",
        "Sportage", "Qashqai", "Sandero", "500", "Octavia", "CX-5",
        "Civic", "XC40", "Cooper", "Compass",
    ]

    static let vehicles: [Vehicle] = plates.enumerated().map { i, plate in
        Vehicle(
            licensePlate: plate,
            brand: brands[i % brands.count],
            model: models[i % models.count],
            clientID: i < clients.count ? clients[i].id : clients[i % clients.count].id
        )
    }

    // MARK: - Assignments (28 active, matches occupied spots)

    static let assignments: [Assignment] = spots.prefix(28).enumerated().map { i, spot in
        let client = clients[i % clients.count]
        let vehicle = vehicles.first { $0.clientID == client.id } ?? vehicles[i]
        return Assignment(
            clientID: client.id,
            vehicleID: vehicle.id,
            spotID: spot.id,
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: ((i % 12) + 1), day: 1))!,
            endDate: nil,
            monthlyRate: Double.random(in: 60...120)
        )
    }

    // MARK: - Payments (January to June for most, some with delays)

    static let payments: [Payment] = {
        var result: [Payment] = []
        for assignment in assignments {
            let paidUpTo = paidUpToMonth(for: assignment)
            for month in 1...paidUpTo {
                let start = Calendar.current.date(from: DateComponents(year: 2026, month: month, day: 1))!
                let end = Calendar.current.date(from: DateComponents(year: 2026, month: month, day: 28))!
                result.append(Payment(
                    assignmentID: assignment.id,
                    amount: assignment.monthlyRate,
                    method: month % 3 == 0 ? .cash : .bizum,
                    date: start,
                    periodMonths: 1,
                    periodStartDate: start,
                    periodEndDate: end
                ))
            }
        }
        return result
    }()

    private static func paidUpToMonth(for assignment: Assignment) -> Int {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let index = assignments.firstIndex { $0.id == assignment.id } ?? 0
        if index < 10 { return currentMonth }
        if index < 18 { return max(1, currentMonth - 2) }
        return max(0, currentMonth - 4)
    }
}
