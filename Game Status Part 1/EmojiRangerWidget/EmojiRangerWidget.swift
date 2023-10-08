import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .panda)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), character: .panda)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [
            .init(date: Date(), character: .panda)
        ]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let character: CharacterDetail
}

struct EmojiRangerWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        AvatarView(entry.character)
    }
}

struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EmojiRangerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Emoji Ranger Detail")
        .description("Keep track of your favorite emoji ranger")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    EmojiRangerWidget()
} timeline: {
    SimpleEntry(date: .now, character: .panda)
}
