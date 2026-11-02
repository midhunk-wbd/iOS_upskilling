import Foundation
import Playgrounds

extension Phase00 {

    static func volumeMessage(for device: String, level: Int = 50) -> String {
        return "\(device) volume set to \(level)"
    }

    static func boost(_ volume: inout Int, by amount: Int) {
        volume = min(volume + amount, 100)
    }

    static func applyTwice(_ value: Int, _ operation: (Int) -> Int) -> Int {
        return operation(operation(value))
    }

    static func functionsAndClosures() -> [String] {
        var volume = 80
        boost(&volume, by: 30)

        let double: (Int) -> Int = { number in
            return number * 2
        }

        let devices = ["Speaker", "TV", "Display"]
        let sortedDevices = devices.sorted { $0 < $1 }

        return [
            volumeMessage(for: "TV"),
            volumeMessage(for: "Speaker", level: 20),
            "Boosted volume: \(volume)",
            "Double twice: \(applyTwice(5, double))",
            "Add 10 twice: \(applyTwice(5) { $0 + 10 })",
            "Sorted: \(sortedDevices.joined(separator: ", "))"
        ]
    }
}

#Playground("E04 Functions & Closures") {
    let results = Phase00.functionsAndClosures()
    print(results)
}
