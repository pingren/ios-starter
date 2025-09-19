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

  private let uuidGenerator: () -> String

  public init(uuidGenerator: @escaping () -> String = { UUID().uuidString }) {
    self.uuidGenerator = uuidGenerator
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .sendDraft(draft):
        // For MVP we simply append the draft locally and echo a fake response.
        state.messages.append(draft.toMessage(id: uuidGenerator(), user: .init(id: "me")))
        state.messages.append(
          Message(id: uuidGenerator(), user: .init(id: "bot"), text: "Echo: \(draft.text)")
        )
        return .none
      }
    }
  }
}

#if DEBUG
// MARK: - Testing Helper

extension ChatFeature {
  /// Create a ChatFeature with a deterministic UUID generator for testing
  public static func testValue(uuidGenerator: @escaping () -> String) -> ChatFeature {
    ChatFeature(uuidGenerator: uuidGenerator)
  }
}
#endif

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
