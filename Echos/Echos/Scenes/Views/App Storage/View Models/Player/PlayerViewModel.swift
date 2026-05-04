//
//  PlayerViewModel.swift
//  Echos
//
//  Created by Emma on 14.11.25.
//

import Foundation

enum MeditationTrack: CaseIterable {
    case birds
    case calmness
    case cheerfulness
    case inspiration
    case rain
    case sea
    case storm
}

extension MeditationTrack {
    var fileName: String {
        switch self {
        case .birds:        return "Birds"
        case .calmness:     return "Calmness"
        case .cheerfulness: return "Cheerfulness"
        case .inspiration:  return "Inspiration"
        case .rain:         return "Rain"
        case .sea:          return "Sea"
        case .storm:        return "Storm"
        }
    }
    
    var fileExtension: String {
        return "wav"
    }
}

protocol MeditationAudioServiceProtocol: AnyObject {
    var duration: TimeInterval { get }
    var currentTime: TimeInterval { get }
    var isPlaying: Bool { get }
    func load(track: MeditationTrack) throws
    
    func play()
    func pause()
    func seek(to time: TimeInterval)
    
    var onFinished: (() -> Void)? { get set }
}


final class PlayerViewModel {
    
    // MARK: - Outputs для ViewController / View
    
    var onIsPlayingChanged: ((Bool) -> Void)?
    var onTimeChanged: ((String) -> Void)?
    var onPlaybackFinished: (() -> Void)?
    
    // MARK: - Dependencies
    
    private let audioService: MeditationAudioServiceProtocol
    
    // MARK: - State
    
    private(set) var currentTrack: MeditationTrack
    private(set) var isPlaying: Bool = false {
        didSet {
            guard oldValue != isPlaying else { return }
            onIsPlayingChanged?(isPlaying)
        }
    }
    
    private var timer: Timer?
    
    // MARK: - Init
    
    init(
        audioService: MeditationAudioServiceProtocol,
        initialTrack: MeditationTrack
    ) {
        self.audioService = audioService
        self.currentTrack = initialTrack
        bindAudioService()
        load(track: initialTrack)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        updateTimeLabel()
        isPlaying = audioService.isPlaying
    }
    
    // MARK: - Работа с треками
    
    func selectTrack(_ track: MeditationTrack) {
        stopTimer()
        isPlaying = false
        currentTrack = track
        load(track: track)
        updateTimeLabel()
    }
    
    private func load(track: MeditationTrack) {
        do {
            try audioService.load(track: track)
        } catch {
            print("Failed to load track: \(error)")
        }
    }
        
    func togglePlayPause() {
        isPlaying ? pause() : play()
    }
    
    func play() {
        audioService.play()
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        audioService.pause()
        isPlaying = false
        stopTimer()
    }
    
    func seek(to time: TimeInterval) {
        audioService.seek(to: time)
        updateTimeLabel()
    }
    
    // MARK: - Private
    
    private func bindAudioService() {
        audioService.onFinished = { [weak self] in
            guard let self else { return }
            self.handleTrackFinished()
        }
    }
    
    private func handleTrackFinished() {
        stopTimer()
        isPlaying = false
        updateTimeLabel()
        playNextTrack()
    }
    
    private func playNextTrack() {
        let allTracks = MeditationTrack.allCases
        guard let currentIndex = allTracks.firstIndex(of: currentTrack) else {
            return
        }
        
        let nextIndex = (currentIndex + 1) % allTracks.count
        let nextTrack = allTracks[nextIndex]
        
        currentTrack = nextTrack
        load(track: nextTrack)
        updateTimeLabel()
        
        audioService.play()
        isPlaying = true
        startTimer()
    }
    
    private func startTimer() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true,
                                     block: { [weak self] _ in
            self?.updateTimeLabel()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeLabel() {
        let current = audioService.currentTime
        let duration = audioService.duration
        let remaining = max(duration - current, 0)
        let text = Self.formatTime(remaining)
        onTimeChanged?(text)
    }
    
    private static func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
