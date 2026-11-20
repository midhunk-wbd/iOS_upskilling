import Testing
@testable import iOS_upskilling

@MainActor
struct ConnectionStateMachineTests {

    let tv = Phase01.CastDevice(id: "tv-1", name: "Living Room TV", type: .tv)
    let speaker = Phase01.CastDevice(id: "speaker-1", name: "Bedroom Speaker", type: .speaker)

    @Test func startsDisconnected() {
        let machine = Phase01.ConnectionStateMachine()
        #expect(machine.state == .disconnected)
    }

    @Test func fullJourneyWorks() throws {
        var machine = Phase01.ConnectionStateMachine()

        try machine.transition(to: .discovering)
        try machine.transition(to: .connecting(tv))
        try machine.transition(to: .connected(tv))
        try machine.transition(to: .disconnected)

        #expect(machine.state == .disconnected)
    }

    @Test func historyRecordsEveryStep() throws {
        var machine = Phase01.ConnectionStateMachine()

        try machine.transition(to: .discovering)
        try machine.transition(to: .connecting(tv))
        try machine.transition(to: .connected(tv))
        try machine.transition(to: .disconnected)

        #expect(machine.history == [.disconnected, .discovering, .connecting(tv), .connected(tv), .disconnected])
    }

    @Test func droppedConnectionReconnects() throws {
        var machine = Phase01.ConnectionStateMachine()

        try machine.transition(to: .discovering)
        try machine.transition(to: .connecting(tv))
        try machine.transition(to: .connected(tv))
        try machine.transition(to: .reconnecting(tv))
        try machine.transition(to: .connected(tv))

        #expect(machine.state == .connected(tv))
    }

    @Test func canRetryAfterFailure() throws {
        var machine = Phase01.ConnectionStateMachine()

        try machine.transition(to: .discovering)
        try machine.transition(to: .failed(.timeout))
        try machine.transition(to: .discovering)

        #expect(machine.state == .discovering)
    }

    @Test func cannotJumpStraightToConnected() {
        #expect(Phase01.canTransition(from: .disconnected, to: .connected(tv)) == false)
    }

    @Test func cannotSwitchDevices() {
        #expect(Phase01.canTransition(from: .connecting(tv), to: .connected(speaker)) == false)
    }

    @Test func illegalMoveThrowsAndKeepsState() throws {
        var machine = Phase01.ConnectionStateMachine()
        try machine.transition(to: .discovering)

        #expect(throws: Phase01.TransitionError.self) {
            try machine.transition(to: .connected(tv))
        }
        #expect(machine.state == .discovering)
    }
}

