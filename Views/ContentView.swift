import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigation: NavigationManager
    @State private var isCursorVisible = true
    @State private var showAboutView = false
    @State private var isMuted: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                Color(hex: "#0D0D0D").ignoresSafeArea()
                    .overlay(
                        Color(hex: "#5C2D91").opacity(0.15)
                            .blur(radius: 50)
                            .edgesIgnoringSafeArea(.all)
                    )
                
                VStack(spacing: 0) {
                    Text("COMMAND QUEST")
                        .font(.system(size: 80, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color(hex: "#78FF00"))
                        .shadow(color: Color(hex: "#78FF00").opacity(0.8), radius: 10, x: 0, y: 0)
                        .overlay(
                            Text("COMMAND QUEST")
                                .font(.system(size: 80, weight: .heavy, design: .monospaced))
                                .foregroundColor(Color(hex: "#78FF00").opacity(0.6))
                                .blur(radius: 3)
                        )
                        .padding(.top, 40)
                    
                    Spacer(minLength: 50)
                    

                    VStack(alignment: .leading, spacing: 3) {
                        Text("XE03J@command-Quest-Virtual-Platform:~$ lsb_release -a")
                            .foregroundColor(Color(hex: "#78FF00"))
                        Text("No LSB modules are available")
                            .foregroundColor(Color(hex: "#00E6FF"))
                        Text("Distributor ID:\tOroTech")
                            .foregroundColor(Color(hex: "#00E6FF"))
                        Text("Description:\tOrozcoOS 3.3.2 LTS")
                            .foregroundColor(Color(hex: "#00E6FF"))
                        Text("Release:\t3.3.2")
                            .foregroundColor(Color(hex: "#00E6FF"))
                        Text("Codename:\tAsuka")
                            .foregroundColor(Color(hex: "#00E6FF"))
                        
                        HStack {
                            Text("XE03J@command-Quest-Virtual-Platform:~$")
                                .foregroundColor(Color(hex: "#78FF00"))
                            Rectangle()
                                .fill(Color(hex: "#78FF00"))
                                .opacity(isCursorVisible ? 1 : 0)
                                .frame(width: 8, height: 27)
                                .animation(
                                    Animation.linear(duration: 0.5)
                                        .repeatForever(autoreverses: true),
                                    value: isCursorVisible)
                                .onAppear {
                                    self.isCursorVisible.toggle()
                                }
                        }
                    }
                    .font(.system(size: 28, design: .monospaced))
                    .padding(20)
                    .background(Color(hex: "#0D0D0D").opacity(0.9))
                    .cornerRadius(8)
                    .shadow(color: Color(hex: "#78FF00").opacity(0.4), radius: 5, x: 0, y: 0)
                    
                    Spacer(minLength: 40)
                    
                    Button("Start") {
                        Task {
                                await SoundManager.shared.playSound(named: "iniciarSound") // 🔊 Reproducir sonido
                            }
                        navigation.navigate(to: .levelSelect)
                    }
                    .padding()
                    .font(.system(size: 55, weight: .heavy, design: .monospaced))
                    .background(Color(hex: "#78FF00"))
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#78FF00"), radius: 5)
                    .padding(.bottom, 20)
                    
                    Spacer()

                    HStack {
                        Button(action: {
                            navigation.navigate(to: .about)
                        }) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("ABOUT")
                            }
                            .foregroundColor(Color(hex: "#78FF00"))
                            .font(.title2)
                        }
                        Spacer()
                    
                        Button(action: {
                                                    Task {
                                                        await SoundManager.shared.toggleMute()
                                                        isMuted = await SoundManager.shared.getMuteState() // ✅ Estado sincronizado
                                                    }
                                                }) {
                                                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.3.fill")
                                                        .font(.title)
                                                        .foregroundColor(Color(hex: "#78FF00"))
                                                }
                                                .frame(width: 50, height: 50) // 🔹 Evita que mueva la UI al cambiar icono
                                                .padding(.trailing, 20)
                                            }
                                            .padding(.leading, 20)
                                            .padding(.bottom, 20)
                }
            }
            .onAppear {
                Task {
                    await SoundManager.shared.playBackgroundMusic(named: "bS")
                }
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .levelSelect:
                    LevelSelectView().environmentObject(navigation)
                case .level(let level):
                    LevelView(level: level).environmentObject(navigation)
                case .about:
                    AboutView().environmentObject(navigation)
                default:
                    ContentView().environmentObject(navigation)
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        switch hex.count {
        case 6:
            (a, r, g, b) = (1, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        case 8:
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0)
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
