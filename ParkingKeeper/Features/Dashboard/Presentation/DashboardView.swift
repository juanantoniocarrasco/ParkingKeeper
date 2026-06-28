import SwiftUI

struct DashboardView: View {
    @State private var viewState: ViewState = .loaded(DashboardView.mockModel)

    var body: some View {
        content
    }
}

// MARK: - Subviews
private extension DashboardView {
    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let model):
            loadedView(model)
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Loading...")
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedView(_ model: Model) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                statCard(
                    title: "Occupied Spots",
                    value: "\(model.occupiedSpots)/\(model.totalSpots)",
                    systemImage: "parkingsign",
                    color: .blue
                )
                statCard(
                    title: "Pending Payments",
                    value: "\(model.pendingPayments)",
                    systemImage: "creditcard",
                    color: .orange
                )
            }
            .padding()
        }
    }

    func statCard(title: String, value: String, systemImage: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(color)
            Text(value)
                .font(.title)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Subtypes
extension DashboardView {
    struct Model {
        let totalSpots: Int
        let occupiedSpots: Int
        let pendingPayments: Int
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        totalSpots: 6,
        occupiedSpots: 2,
        pendingPayments: 1
    )
}

#Preview("Loaded") {
    DashboardView()
}
