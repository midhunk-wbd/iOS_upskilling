import Foundation
import Playgrounds

extension Phase00 {

    enum DeviceType: String, CaseIterable, Equatable {
        case tv
        case speaker
        case display

        var symbolName: String {
            switch self {
            case .tv:
                return "tv"
            case .speaker:
                return "hifispeaker"
            case .display:
                return "display"
            }
        }
    }

    enum ConnectionState: Equatable {
        case disconnected
        case connecting(attempt: Int)
        case connected(deviceName: String)
        case failed(reason: String)

        var message: String {
            switch self {
            case .disconnected:
                return "Disconnected"
            case .connecting(let attempt):
                return "Connecting (attempt \(attempt))..."
            case .connected(let deviceName):
                return "Connected to \(deviceName)"
            case .failed(let reason):
                return "Failed: \(reason)"
            }
        }
    }

    struct CastDevice: Equatable {
        let name: String
        let type: DeviceType
        var signalStrength: Int
        var state: ConnectionState = .disconnected

        var isConnected: Bool {
            if case .connected = state {
                return true
            }
            return false
        }

        mutating func connect() {
            state = .connected(deviceName: name)
        }

        mutating func disconnect() {
            state = .disconnected
        }
    }

    struct Volume {
        var level: Int {
            didSet {
                level = min(max(level, 0), 100)
            }
        }

        var isMuted: Bool {
            return level == 0
        }

        init(_ level: Int) {
            self.level = min(max(level, 0), 100)
        }

        mutating func increase(by amount: Int = 10) {
            level += amount
        }
    }
}

extension Phase00.CastDevice: CustomStringConvertible {
    static let sample = Phase00.CastDevice(name: "Living Room TV", type: .tv, signalStrength: 90)

    var description: String {
        return "\(name) (\(type.rawValue)) — \(state.message)"
    }
}

#Playground("E03 Structs & Enums") {
    let types = Phase00.DeviceType.allCases.map { "\($0.rawValue): \($0.symbolName)" }
    let fromRaw = Phase00.DeviceType(rawValue: "speaker")
    let badRaw = Phase00.DeviceType(rawValue: "fridge")

    let states: [Phase00.ConnectionState] = [
        .disconnected, .connecting(attempt: 2), .connected(deviceName: "TV"), .failed(reason: "Timeout")
    ]
    let messages = states.map(\.message)

    var tv = Phase00.CastDevice(name: "TV", type: .tv, signalStrength: 90)
    let before = tv.isConnected
    tv.connect()
    let after = tv.isConnected
    let msg = tv.state.message

    var volume = Phase00.Volume(150)
    let startLevel = volume.level
    volume.level = -20
    let clampedLevel = volume.level
    let muted = volume.isMuted
    volume.increase()
    let afterIncrease = volume.level
    volume.increase(by: 500)
    let maxLevel = volume.level

    let sample = Phase00.CastDevice.sample
    let same = sample == Phase00.CastDevice.sample
    print(sample)

    let original = Phase00.CastDevice.sample
    var copy = original
    copy.connect()
    let originalConnected = original.isConnected
    let copyConnected = copy.isConnected
}
