import Foundation
import Combine

extension Phase02 {

    final class DeviceDiscoveryLogger {
        private let engine: FakeCastEngine
        private var cancellables = Set<AnyCancellable>()
        private(set) var logs: [String] = []

        init(engine: FakeCastEngine) {
            self.engine = engine
        }

        func start() {
            engine.eventsPublisher
                .sink { [weak self] event in
                    switch event {
                    case .appeared(let device):
                        self?.log("+ \(device.name) appeared")
                    case .disappeared(let device):
                        self?.log("- \(device.name) disappeared")
                    }
                }
                .store(in: &cancellables)

            engine.devicesPublisher
                .map { devices in devices.map { $0.name } }
                .removeDuplicates()
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { [weak self] names in
                    self?.log("Devices (\(names.count)): \(names.joined(separator: ", "))")
                }
                .store(in: &cancellables)

            engine.devicesPublisher
                .map { devices in devices.filter { $0.type == .tv }.count }
                .removeDuplicates()
                .filter { $0 > 0 }
                .sink { [weak self] count in
                    self?.log("TVs available: \(count)")
                }
                .store(in: &cancellables)
        }

        func stop() {
            cancellables.removeAll()
        }

        private func log(_ message: String) {
            logs.append(message)
            print(message)
        }

        deinit {
            print("DeviceDiscoveryLogger deallocated")
        }
    }
}
