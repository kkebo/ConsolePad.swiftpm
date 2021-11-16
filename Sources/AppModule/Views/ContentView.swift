import SwiftUI

struct ContentView {}

extension ContentView: View {
    var body: some View {
        NavigationView {
            ConsoleView()
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewPresets()
    }
}
