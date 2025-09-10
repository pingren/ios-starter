import ChatFeature
import ComposableArchitecture
import SwiftUI

@main
struct ChatPreviewApp: App {
  var body: some Scene {
    WindowGroup {
      ChatFeatureView(
        store: Store(initialState: ChatFeature.State()) {
          ChatFeature()
        }
      )
    }
  }
}
