//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by Admin on 08.10.2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {

    private func character(for configuration: CharacterSelectionIntent) -> CharacterDetail {
        switch configuration.hero {
        case .panda:
                .panda
        case .egghead:
                .egghead
        case .spouty:
                .spouty
        case .unknown:
                .panda
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .panda, relevance: nil)
    }

    func getSnapshot(
        for configuration: CharacterSelectionIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> ()
    ) {
        let entry = SimpleEntry(date: Date(), character: .panda, relevance: nil)
        completion(entry)
    }

    func getTimeline(
        for configuration: CharacterSelectionIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        let selectedCharacter = character(for: configuration)
        let endDate = selectedCharacter.fullHealthDate
        let oneMinute: TimeInterval = 60
        var currentDate = Date()

        var entries: [SimpleEntry] = []

        while currentDate < endDate {
            let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
            let entry = SimpleEntry(date: currentDate, character: selectedCharacter, relevance: relevance)
            currentDate += oneMinute
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let character: CharacterDetail
    let relevance: TimelineEntryRelevance?
}

struct EmojiRangerWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            AvatarView(entry.character)
                .widgetURL(entry.character.url)
        default:
                HStack(alignment: .top) {
                    AvatarView(entry.character)
                    Text(entry.character.bio)
                        .padding()

                }
                .foregroundColor(.white)
                .widgetURL(entry.character.url)
                .background(Color.gameBackground)
        }
    }
}

struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: CharacterSelectionIntent.self,
            provider: Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                EmojiRangerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                EmojiRangerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Emoji Ranger Detail")
        .description("Keep track of your favorite emoji ranger")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    EmojiRangerWidget()
} timeline: {
    SimpleEntry(date: .now, character: .panda, relevance: nil)
}

#Preview(as: .systemSmall) {
    EmojiRangerWidget()
} timeline: {
    SimpleEntry(date: .now, character: .panda, relevance: nil)
}
