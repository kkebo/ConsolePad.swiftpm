import SwiftUI

struct ContentView {}

extension ContentView: View {
    var body: some View {
        NavigationStack {
            ConsoleView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewPresets()
    }
}
