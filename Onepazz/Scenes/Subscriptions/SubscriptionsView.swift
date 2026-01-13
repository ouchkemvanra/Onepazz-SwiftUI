//
//  SubscriptionsView.swift
//  Onepazz
//
//  Created by Ouch Kemvanra on 8/25/25.
//

import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var env: AppEnvironment
    @State private var state: ViewState<[Subscription]> = .idle

    var body: some View {
        Group {
            switch state {
            case .idle, .loading:
                LoadingView(message: L10n.loading)
            case .empty:
                EmptyStateView(systemImage: "creditcard", title: L10n.noSubs, message: L10n.nothing)
            case .failed(let error):
                ErrorStateView(message: error.localizedDescription) { Task { await load() } }
            case .loaded(let subs):
                List(subs, id: \.id) { sub in
                    HStack {
                        Image(systemName: "checkmark.seal")
                        VStack(alignment: .leading) {
                            Text(sub.name).appFont(.headline)
                            Text(sub.id).appFont(.footnote).foregroundStyle(AppColor.textSecondary)
                        }
                    }
                    .padding(.vertical, Spacing.s)
                }
            }
        }
        .navigationTitle("Subscriptions")
        .task { await load() }
    }

    @MainActor
    private func load() async {
        state = .loading
        do {
            let items = try await env.subscriptionsService.fetch()
            state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            state = .failed(error)
        }
    }
}

#Preview {
    SubscriptionsView()
        .environmentObject(AppEnvironment())
}
