import SwiftUI

struct SpotGridView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(SpotGridView.effectiveMocks)

    var body: some View {
        content
    }
}

// MARK: - Subviews
private extension SpotGridView {
    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let spots):
            loadedView(spots)
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Cargando plazas...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "Sin plazas",
            systemImage: "parkingsign.slash",
            description: Text("Añade plazas para gestionar tu parking.")
        )
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedView(_ spots: [SpotItem]) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                legend
                grid(spots)
            }
            .padding()
        }
    }

    var legend: some View {
        HStack(spacing: 20) {
            legendItem(color: .green, label: "Libre", icon: "car.fill")
            legendItem(color: .red, label: "Ocupada", icon: "car")
        }
        .font(.caption)
    }

    func legendItem(color: Color, label: String, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(label)
                .foregroundStyle(.secondary)
        }
    }

    func grid(_ spots: [SpotItem]) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(spots) { spot in
                spotCell(spot)
            }
        }
    }

    func spotCell(_ spot: SpotItem) -> some View {
        let isFree = spot.status == .free
        return Button {
            if !isFree {
                let assignment = DemoData.assignments.first { $0.spotID == spot.id && $0.endDate == nil }
                if let a = assignment {
                    coordinator.navigate(to: .assignmentDetail(a))
                }
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isFree ? .green.opacity(0.15) : .red.opacity(0.15))
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFree ? .green.opacity(0.4) : .red.opacity(0.4), lineWidth: 1.5)
                    Image(systemName: isFree ? "car.fill" : "car")
                        .font(.title3)
                        .foregroundStyle(isFree ? .green : .red)
                }
                .frame(height: 60)

                Text("\(spot.number)")
                    .font(.caption)
                    .bold()
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Subtypes
extension SpotGridView {
    struct SpotItem: Identifiable {
        let id: UUID
        let number: Int
        let status: SpotItemStatus
    }

    enum SpotItemStatus {
        case free
        case occupied
    }

    enum ViewState {
        case loading
        case loaded([SpotItem])
        case empty
        case error(String)
    }
}

// MARK: - Mocks
extension SpotGridView {
    static let mocks: [SpotItem] = SpotViewMapper.toGridItems([
        .mockSpot1, .mockSpot2, .mockSpot3,
        .mockSpot4, .mockSpot5, .mockSpot6,
    ])

    static var effectiveMocks: [SpotItem] {
        if DemoData.isEnabled {
            return SpotViewMapper.toGridItems(DemoData.spots)
        }
        return mocks
    }
}

#Preview("Cargado") {
    SpotGridView()
        .environment(NavigationCoordinator())
}
