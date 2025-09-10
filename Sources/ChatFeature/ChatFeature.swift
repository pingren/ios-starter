import Chat
import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

public struct ChatFeature: Reducer {
  public struct State: Equatable {
    public var messages: [Message]
    public init(messages: [Message] = []) {
      self.messages = messages
    }
  }

  public enum Action: Equatable {
    case sendDraft(DraftMessage)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .sendDraft(draft):
        // For MVP we simply append the draft locally and echo a fake response.
        state.messages.append(draft.toMessage(id: UUID().uuidString, user: .init(id: "me")))
        state.messages.append(
          Message(id: UUID().uuidString, user: .init(id: "bot"), text: "Echo: \(draft.text)")
        )
        return .none
      }
    }
  }
}

// MARK: - View

public struct ChatFeatureView: View {
  let store: StoreOf<ChatFeature>

  public init(store: StoreOf<ChatFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ChatView(messages: viewStore.messages) { draft in
        viewStore.send(.sendDraft(draft))
      }
    }
  }
}
