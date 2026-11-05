import Foundation
import Playgrounds

extension Phase01 {
// might add more in further implementation.
    enum FailureReason: Equatable {
        case deviceNotFound
        case timeout
        case networkLost
    }

    enum ConnectionState: Equatable {
        case disconnected
        case discovering
        case connecting(CastDevice)
        case connected(CastDevice)
        case reconnecting(CastDevice)
        case failed(FailureReason)

        var title: String {
            switch self {
            case .disconnected:
                return "Disconnected"
            case .discovering:
                return "Searching for devices..."
            case .connecting(let device):
                return "Connecting to \(device.name)..."
            case .connected(let device):
                return "Connected to \(device.name)"
            case .reconnecting(let device):					
                return "Reconnecting to \(device.name)..."
            case .failed(let reason):
                return "Failed: \(reason)"
            }
        }
    }
}

#Playground("Phase 1 States") {
    let tv = Phase01.CastDevice(id: "tv-1", name: "Living Room TV", type: .tv)

    let states: [Phase01.ConnectionState] = [
        .disconnected,
        .discovering,
        .connecting(tv),
        .connected(tv),
        .reconnecting(tv),
        .failed(.timeout)
    ]

    let titles = states.map { $0.title }
    print(titles)
}
  
