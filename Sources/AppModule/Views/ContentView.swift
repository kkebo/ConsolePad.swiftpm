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
