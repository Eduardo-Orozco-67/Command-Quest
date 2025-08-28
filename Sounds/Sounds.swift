import AVFoundation
import UIKit

actor SoundManager {
    static let shared = SoundManager() // Singleton seguro para concurrencia
    
    private var audioPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    // Estado global del sonido
        private var isSoundEnabled: Bool {
            get { UserDefaults.standard.bool(forKey: "isSoundEnabled") }
            set { UserDefaults.standard.set(newValue, forKey: "isSoundEnabled") }
        }
        
        private var isMuted: Bool {
            get { UserDefaults.standard.bool(forKey: "isMuted") }
            set { UserDefaults.standard.set(newValue, forKey: "isMuted") }
        }
        
        init() {
            Task {
                await resetSoundSettingsIfNeeded()
            } 
        }

        // 🔹 Resetea la configuración solo si la app se abre por primera vez
        private func resetSoundSettingsIfNeeded() async {
            if UserDefaults.standard.object(forKey: "isSoundEnabled") == nil {
                isSoundEnabled = true // 🔹 Activa el sonido la primera vez
                isMuted = false
            }
        }

        // 🔊 Reproduce un efecto de sonido (si no está muteado)
        func playSound(named fileName: String) async {
            guard !isMuted, let soundData = NSDataAsset(name: fileName)?.data else { return }
            do {
                audioPlayer = try AVAudioPlayer(data: soundData)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("❌ Error al reproducir sonido desde Assets: \(error.localizedDescription)")
            }
        }

        // 🎵 Reproduce música de fondo en loop
        func playBackgroundMusic(named fileName: String) async {
            guard let soundData = NSDataAsset(name: fileName)?.data else { return }
            do {
                backgroundMusicPlayer = try AVAudioPlayer(data: soundData)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.volume = isMuted ? 0 : 0.5
                if !isMuted {
                    backgroundMusicPlayer?.play()
                }
            } catch {
                print("❌ Error al reproducir música de fondo: \(error.localizedDescription)")
            }
        }

        // 🔇 Alternar Mute
        func toggleMute() async {
            let newState = !isMuted // 🔹 Alternamos el estado
            isMuted = newState
            backgroundMusicPlayer?.volume = newState ? 0 : 0.5
            if newState {
                backgroundMusicPlayer?.pause()
            } else {
                backgroundMusicPlayer?.play()
            }
        }

        // 🔄 Verifica si el sonido está activo (para usar en ContentView)
        func getMuteState() async -> Bool {
            return isMuted
        }
    
    // ⏸️ Pausar la música de fondo
    func pauseBackgroundMusic() async {
        backgroundMusicPlayer?.pause()
    }

    // ▶️ Reanudar la música de fondo
    func resumeBackgroundMusic() async {
        backgroundMusicPlayer?.play()
    }

    // ⏹️ Detener la música de fondo
    func stopBackgroundMusic() async {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
}


