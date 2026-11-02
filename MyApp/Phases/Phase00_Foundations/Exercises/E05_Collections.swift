import Foundation
import Playgrounds

extension Phase00 {

    static func collections() -> [String] {
        var devices = ["TV", "Speaker"]
        devices.append("Display")
        let removed = devices.remove(at: 0)

        let strengths = [90, 45, 20, 75]
        let strong = strengths.filter { $0 >= 60 }
        let percents = strengths.map { "\($0)%" }
        let total = strengths.reduce(0, +)

        var signals: [String: Int] = ["TV": 90, "Speaker": 45]
        signals["Display"] = 70
        signals["Speaker"] = nil

        var rooms: Set<String> = ["Living Room", "Bedroom"]
        rooms.insert("Living Room")

        return [
            "Devices: \(devices), removed \(removed)",
            "Strong: \(strong)",
            "Percents: \(percents.joined(separator: " "))",
            "Total: \(total)",
            "Signals: \(signals.keys.sorted())",
            "Rooms: \(rooms.count)"
        ]
    }
}

#Playground("E05 Collections") {
    let results = Phase00.collections()
    print(results)
}
