import Foundation

extension Phase01 {

    enum DeviceType: Equatable {
        case tv
        case speaker
        case display
    }

    struct CastDevice: Equatable {
        let id: String
        let name: String
        let type: DeviceType
    }
}
