import Foundation
import Playgrounds

extension Phase00 {
    static func variablesAndTypes() -> [String] {
        let appName = "Cast"
        
        var connectionAttempts = 1
        connectionAttempts += 1 // var is changable
        
        let volume: Double = 0.75
        
        let isConnected = false
        
        let deviceNames: [String] = ["Living Room TV", "Bedroom Speaker"]
        
        let signalStrength: [String: Int] = ["Living Room TV": 80, "Bedroom Speaker": 60]
        
        return [
            "App: \(appName)",
            "Attempts: \(connectionAttempts)",
            "Volume: \(Int(volume * 100))%",
            "Connected: \(isConnected)",
            "Devices: \(deviceNames.joined(separator: ", "))",
            "TV signal: \(signalStrength["Living Room TV", default: 0])"
        ]
        
    }
}

#Playground("E01 Variables") {
    let results = Phase00.variablesAndTypes()
    print(results)
}
