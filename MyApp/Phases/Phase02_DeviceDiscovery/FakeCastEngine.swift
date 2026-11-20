import Foundation
import Combine

extension Phase02 {

    enum DiscoveryEvent: Equatable {
        case appeared(Phase01.CastDevice)
        case disappeared(Phase01.CastDevice)
    }

    final class FakeCastEngine {
        private let devicePool: [Phase01.CastDevice] = [
            Phase01.CastDevice(id: "tv-1", name: "Living Room TV", type: .tv),
            Phase01.CastDevice(id: "tv-2", name: "Bedroom TV", type: .tv),
            Phase01.CastDevice(id: "speaker-1", name: "Kitchen Speaker", type: .speaker),
            Phase01.CastDevice(id: "speaker-2", name: "Office Speaker", type: .speaker),
            Phase01.CastDevice(id: "display-1", name: "Hallway Display", type: .display)
        ]

        private let devicesSubject = CurrentValueSubject<[Phase01.CastDevice], Never>([])
        private let eventsSubject = PassthroughSubject<DiscoveryEvent, Never>()
        private var timerCancellable: AnyCancellable?

        var devicesPublisher: AnyPublisher<[Phase01.CastDevice], Never> {
            devicesSubject.eraseToAnyPublisher()
        }

        var eventsPublisher: AnyPublisher<DiscoveryEvent, Never> {
            eventsSubject.eraseToAnyPublisher()
        }

        var currentDevices: [Phase01.CastDevice] {
            devicesSubject.value
        }

        var isDiscovering: Bool {
            timerCancellable != nil
        }

        func startDiscovery(every interval: TimeInterval = 1) {
            guard timerCancellable == nil else {
                return
            }

            timerCancellable = Timer.publish(every: interval, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.tick()
                }
        }

        func stopDiscovery() {
            timerCancellable?.cancel()
            timerCancellable = nil
        }

        func tick() {
            var devices = devicesSubject.value
            let notFoundYet = devicePool.filter { !devices.contains($0) }
            let shouldAdd = devices.count < 2 || (Bool.random() && !notFoundYet.isEmpty)

            if shouldAdd, let newDevice = notFoundYet.randomElement() {
                devices.append(newDevice)
                eventsSubject.send(.appeared(newDevice))
                devicesSubject.send(devices)
            } else if let lostDevice = devices.randomElement() {
                devices.removeAll { $0 == lostDevice }
                eventsSubject.send(.disappeared(lostDevice))
                devicesSubject.send(devices)
            }
        }

        deinit {
            print("FakeCastEngine deallocated")
        }
    }
}
