import Foundation
import Playgrounds

extension Phase00 {

    static func parseVolume(_ input: String) -> Int {
        return Int(input) ?? 50
    }

    static func signalDescription(for name: String, in signals: [String: Int]) -> String {
        if let strength = signals[name] {
            return "\(name): \(strength)%"
        } else {
            return "\(name): not found"
        }
    }

    static func connect(to name: String?, strength: Int?) -> String {
        guard let name = name, !name.isEmpty, let strength = strength, strength >= 20 else {
            return "Cannot connect"
        }
        return "Connecting to \(name)..."
    }

    static func signalLabel(_ strength: Int) -> String {
        switch strength {
        case 0:
            return "No signal"
        case 1..<40:
            return "Weak"
        case 40..<75:
            return "Good"
        case 75...100:
            return "Excellent"
        default:
            return "Invalid"
        }
    }

    static func strongDeviceCount(_ readings: [String: Int?]) -> Int {
        var count = 0
        for (_, reading) in readings {
            guard let strength = reading else {
                continue
            }
            if strength >= 75 {
                count += 1
            }
        }
        return count
    }

    static func attemptsUntilConnected(_ results: [Bool], maxAttempts: Int) -> Int? {
        var attempt = 0
        while attempt < maxAttempts && attempt < results.count {
            if results[attempt] {
                return attempt + 1
            }
            attempt += 1
        }
        return nil
    }

    static func firstDeviceUppercased(_ names: [String]) -> String {
        return names.first?.uppercased() ?? "NO DEVICES"
    }

    static func status(isConnected: Bool, strength: Int) -> String {
        switch (isConnected, strength) {
        case (false, _):
            return "Offline"
        case (true, let s) where s < 40:
            return "Connected (poor)"
        case (true, _):
            return "Connected"
        }
    }
}

#Playground("E02 Optionals & Control Flow") {
    let t1 = [Phase00.parseVolume("80"), Phase00.parseVolume("loud")]

    let signals = ["Living Room TV": 90, "Bedroom Speaker": 30]
    let t2 = [
        Phase00.signalDescription(for: "Living Room TV", in: signals),
        Phase00.signalDescription(for: "Kitchen", in: signals)
    ]

    let t3 = [
        Phase00.connect(to: "TV", strength: 50),
        Phase00.connect(to: nil, strength: 50),
        Phase00.connect(to: "", strength: 50),
        Phase00.connect(to: "TV", strength: 10)
    ]

    let t4 = [0, 25, 60, 100, 150].map(Phase00.signalLabel)

    let t5 = Phase00.strongDeviceCount(["TV": 90, "Speaker": nil, "Display": 80, "Phone": 20])

    let t6 = [
        Phase00.attemptsUntilConnected([false, false, true], maxAttempts: 3),
        Phase00.attemptsUntilConnected([false, false, false, true], maxAttempts: 3),
        Phase00.attemptsUntilConnected([], maxAttempts: 3)
    ]

    let t7 = [Phase00.firstDeviceUppercased(["tv", "speaker"]), Phase00.firstDeviceUppercased([])]

    let t8 = [
        Phase00.status(isConnected: false, strength: 90),
        Phase00.status(isConnected: true, strength: 20),
        Phase00.status(isConnected: true, strength: 90)
    ]
}
