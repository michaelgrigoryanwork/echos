//
//  MeditationAudioService.swift
//  Echos
//
//  Created by Emma on 18.11.25.
//

import AVFoundation

final class MeditationAudioService: NSObject, MeditationAudioServiceProtocol {
    
    private var player: AVAudioPlayer?
    
    var onFinished: (() -> Void)?
    
    // MARK: - Init
    
    override init() {
        super.init()
        configureAudioSession()
    }
    
    // MARK: - MeditationAudioServiceProtocol
    
    var duration: TimeInterval {
        player?.duration ?? 0
    }
    
    var currentTime: TimeInterval {
        player?.currentTime ?? 0
    }
    
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }
    
    func load(track: MeditationTrack) throws {
        guard let url = Bundle.main.url(
            forResource: track.fileName,
            withExtension: track.fileExtension
        ) else {
            throw NSError(
                domain: "MeditationAudioService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "File not found: \(track.fileName).\(track.fileExtension)"]
            )
        }
        
        player = try AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seek(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    // MARK: - Private
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session:", error)
        }
    }
}

extension MeditationAudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinished?()
    }
}
