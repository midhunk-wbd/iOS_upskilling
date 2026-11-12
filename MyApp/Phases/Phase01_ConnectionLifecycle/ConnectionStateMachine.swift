import Foundation
import Playgrounds

extension Phase01 {

    static func canTransition(from current: ConnectionState, to next: ConnectionState) -> Bool {
        switch (current, next) {
        case (.disconnected, .discovering):
            return true

        case (.discovering, .connecting),
             (.discovering, .disconnected),
             (.discovering, .failed):
            return true

        case (.connecting(let device), .connected(let connectedDevice)):
            return device == connectedDevice
        case (.connecting, .failed),
             (.connecting, .disconnected):
            return true

        case (.connected(let device), .reconnecting(let reconnectingDevice)):
            return device == reconnectingDevice
        case (.connected, .disconnected):
            return true

        case (.reconnecting(let device), .connected(let connectedDevice)):
            return device == connectedDevice
        case (.reconnecting, .failed),
             (.reconnecting, .disconnected):
            return true

        case (.failed, .disconnected),
             (.failed, .discovering):
            return true

        default:
            return false
        }
    }

    enum TransitionError: Error, Equatable {
        case illegal(from: ConnectionState, to: ConnectionState)
    }

    struct ConnectionStateMachine {
        private(set) var state: ConnectionState = .disconnected
        private(set) var history: [ConnectionState] = [.disconnected]

        mutating func transition(to next: ConnectionState) throws {
            guard Phase01.canTransition(from: state, to: next) else {
                throw TransitionError.illegal(from: state, to: next)
            }
            state = next
            history.append(next)
        }
    }
}

#Playground("Phase 1 Transitions") {
    let tv = Phase01.CastDevice(id: "tv-1", name: "Living Room TV", type: .tv)
    let speaker = Phase01.CastDevice(id: "speaker-1", name: "Bedroom Speaker", type: .speaker)

    var machine = Phase01.ConnectionStateMachine()

    do {
        try machine.transition(to: .discovering)
        try machine.transition(to: .connecting(tv))
        try machine.transition(to: .connected(tv))
        try machine.transition(to: .reconnecting(tv))
        try machine.transition(to: .connected(tv))
        try machine.transition(to: .disconnected)
    } catch {
        print("Unexpected: \(error)")
    }
    print(machine.history.map { $0.title })

    do {
        try machine.transition(to: .connected(speaker))
    } catch {
        print("Rejected: \(error)")
    }
    print("Still: \(machine.state.title)")

    let wrongDevice = Phase01.canTransition(from: .connecting(tv), to: .connected(speaker))
    print("connecting(TV) -> connected(Speaker) allowed: \(wrongDevice)")
}
