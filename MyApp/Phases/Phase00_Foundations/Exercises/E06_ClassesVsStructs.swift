import Foundation
import Playgrounds

extension Phase00 {

    class MediaPlayer {
        let name: String
        var volume: Int

        init(name: String, volume: Int = 50) {
            self.name = name
            self.volume = volume
        }

        func play(_ track: String) -> String {
            return "\(name) playing \(track)"
        }
    }

    class VideoPlayer: MediaPlayer {
        override func play(_ track: String) -> String {
            return super.play(track) + " with video"
        }
    }

    struct PlayerSettings {
        var volume: Int
    }

    static func classesVsStructs() -> [String] {
        let speaker = MediaPlayer(name: "Speaker")
        let sameSpeaker = speaker
        sameSpeaker.volume = 90

        let settings = PlayerSettings(volume: 50)
        var copiedSettings = settings
        copiedSettings.volume = 90

        let tv = VideoPlayer(name: "TV")

        return [
            "Class: \(speaker.volume) and \(sameSpeaker.volume)",
            "Struct: \(settings.volume) and \(copiedSettings.volume)",
            speaker.play("Song"),
            tv.play("Movie")
        ]
    }
}

#Playground("E06 Classes vs Structs") {
    let results = Phase00.classesVsStructs()
    print(results)
}
