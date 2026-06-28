import SwiftUI

struct SpotGridView: View {
    @State private var viewState: ViewState = .loaded(SpotGridView.mocks)

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
        ProgressView("Loading spots...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "No Spots",
            systemImage: "parkingsign.slash",
            description: Text("Add spots to manage your parking.")
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
        let columns = [GridItem(.adaptive(minimum: 80, maximum: 100))]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(spots) { spot in
                    spotCell(spot)
                }
            }
            .padding()
        }
    }

    func spotCell(_ spot: SpotItem) -> some View {
        VStack(spacing: 4) {
            Image(systemName: spot.status == .free ? "car.fill" : "car")
                .font(.title2)
                .foregroundStyle(spot.status == .free ? .green : .red)
            Text("\(spot.number)")
                .font(.caption)
                .bold()
            Text(spot.status == .free ? "Free" : "Occupied")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
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
}

#Preview("Loaded") {
    SpotGridView()
}
