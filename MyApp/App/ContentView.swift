import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .task {
                await Phase02.runDiscoveryDemo()
            }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
