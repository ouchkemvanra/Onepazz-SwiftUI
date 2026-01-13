import XCTest
import SwiftUI
@testable import Onepazz

extension XCTestCase {
    func snapshot<V: View>(_ view: V, width: CGFloat = 320, height: CGFloat = 640, name: String) {
        let host = UIHostingController(rootView: view)
        host.view.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        host.view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: host.view.bounds.size)
        let image = renderer.image { ctx in
            host.view.drawHierarchy(in: host.view.bounds, afterScreenUpdates: true)
        }
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

final class SnapshotTests: XCTestCase {
    func testLoadingViewSnapshot() {
        snapshot(LoadingView(message: L10n.loading, isFullscreen: true), name: "LoadingView_fullscreen")
    }
    func testEmptyStateSnapshot() {
        snapshot(EmptyStateView(systemImage: "tray", title: L10n.noSubs, message: L10n.nothing), name: "EmptyStateView")
    }
    func testButtonStylesSnapshot() {
        snapshot(VStack {
            Button("Primary"){}.buttonStyle(PrimaryButtonStyle())
            Button("Secondary"){}.buttonStyle(SecondaryButtonStyle())
            Button("Delete"){}.buttonStyle(DestructiveButtonStyle())
        }.padding(), name: "Buttons")
    }
}