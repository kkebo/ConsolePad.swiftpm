import class Foundation.Bundle

extension Bundle {
    var isPlaygroundPreview: Bool {
        self.bundleIdentifier?.hasPrefix("swift-playgrounds-dev-previews") == true
    }
}
