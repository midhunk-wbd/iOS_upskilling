import Foundation

extension Phase02 {

    static func runDiscoveryDemo(seconds: Int = 8) async {
        print("Discovery started")

        var engine: FakeCastEngine? = FakeCastEngine()
        var logger: DeviceDiscoveryLogger? = engine.map { DeviceDiscoveryLogger(engine: $0) }

        engine?.startDiscovery()
        logger?.start()

        try? await Task.sleep(for: .seconds(seconds))

        logger?.stop()
        engine?.stopDiscovery()
        print("Discovery stopped")

        logger = nil
        engine = nil
    }
}
