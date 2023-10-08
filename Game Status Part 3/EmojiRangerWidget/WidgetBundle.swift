import SwiftUI
import WidgetKit

@main
struct WidgetBundle: SwiftUI.WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        EmojiRangerWidget()
        LeaderboardWidget()
    }
}
