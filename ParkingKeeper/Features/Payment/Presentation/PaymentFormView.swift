import SwiftUI

struct PaymentFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAssignmentID: UUID?
    @State private var amount: String
    @State private var selectedMethod: PaymentMethod = .cash
    @State private var date: Date
    @State private var periodMonths: Int = 1

    private let formModel: Model?
    private let assignmentOptions: [AssignmentOption]

    init(model: Model?) {
        self.formModel = model
        _selectedAssignmentID = State(initialValue: model?.assignmentID)
        _amount = State(initialValue: model != nil ? "\(model!.amount)" : "")
        _selectedMethod = State(initialValue: model?.method ?? .cash)
        _date = State(initialValue: model?.date ?? Date())
        _periodMonths = State(initialValue: model?.periodMonths ?? 1)
        self.assignmentOptions = PaymentFormView.mockAssignments
    }

    var body: some View {
        form
            .navigationTitle(formModel != nil ? "Editar pago" : "Nuevo pago")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension PaymentFormView {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") { save() }
                    .disabled(!isValid)
            }
        }
    }

    var form: some View {
        Form {
            Section("Asignación") {
                Picker("Asignación", selection: $selectedAssignmentID) {
                    Text("Seleccionar asignación").tag(nil as UUID?)
                    ForEach(assignmentOptions) { assignment in
                        Text(assignment.label).tag(assignment.id as UUID?)
                    }
                }
            }
            Section("Pago") {
                TextField("Importe (€)", text: $amount)
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
                Picker("Método", selection: $selectedMethod) {
                    Text("Efectivo").tag(PaymentMethod.cash)
                    Text("Bizum").tag(PaymentMethod.bizum)
                }
                DatePicker("Fecha", selection: $date, displayedComponents: .date)
                Stepper("\(periodMonths) mes\(periodMonths > 1 ? "es" : "")", value: $periodMonths, in: 1...12)
            }
        }
    }
}

// MARK: - Computed
private extension PaymentFormView {
    var isValid: Bool {
        selectedAssignmentID != nil && Double(amount) != nil
    }
}

// MARK: - Methods
private extension PaymentFormView {
    func save() {
        dismiss()
    }
}

// MARK: - Subtypes
extension PaymentFormView {
    struct Model {
        let id: UUID
        let assignmentID: UUID?
        let amount: Double
        let method: PaymentMethod
        let date: Date
        let periodMonths: Int
    }

    struct AssignmentOption: Identifiable {
        let id: UUID
        let label: String
    }

    static let mockAssignments: [AssignmentOption] = [
        AssignmentOption(id: Assignment.mockActive.id, label: "Maria Garcia — Plaza 2"),
        AssignmentOption(id: Assignment.mockHistoric.id, label: "Carlos Lopez — Plaza 4"),
    ]

    static func mockNew() -> Model {
        Model(id: UUID(), assignmentID: nil, amount: 0, method: .cash, date: Date(), periodMonths: 1)
    }

    static func mockEdit() -> Model {
        Model(
            id: Payment.mockJanuary.id,
            assignmentID: Assignment.mockActive.id,
            amount: Payment.mockJanuary.amount,
            method: Payment.mockJanuary.method,
            date: Payment.mockJanuary.date,
            periodMonths: Payment.mockJanuary.periodMonths
        )
    }
}

#Preview("Nuevo pago") {
    PaymentFormView(model: PaymentFormView.mockNew())
}

#Preview("Editar pago") {
    PaymentFormView(model: PaymentFormView.mockEdit())
}
