import SwiftUI

struct AboutView: View {
    @EnvironmentObject var navigation: NavigationManager
    @State private var animateBackground = false // Para el fondo dinámico
    @State private var isVisible2 = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "#0D0D0D").ignoresSafeArea()
                    .overlay(
                        Color(hex: "#5C2D91")
                            .opacity(animateBackground ? 0.25 : 0.15)
                            .blur(radius: 50)
                            .edgesIgnoringSafeArea(.all)
                    )
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                            animateBackground.toggle()
                        }
                    }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        Text("ABOUT COMMAND QUEST")
                            .font(.system(size: 60  , weight: .heavy, design: .monospaced))
                            .foregroundColor(Color(hex: "#78FF00"))
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .shadow(color: Color(hex: "#78FF00").opacity(0.6), radius: 15)
                            .opacity(animateBackground ? 1 : 0)
                            .animation(.easeInOut(duration: 1.0), value: animateBackground)

                        HStack(spacing: 20) {
                            Image(systemName: "terminal.fill")
                                .foregroundColor(Color(hex: "#78FF00")) // Verde neón
                                .font(.system(size: 50))
                                .scaleEffect(isVisible2 ? 1.1 : 0.9)
                                .shadow(color: Color(hex: "#78FF00").opacity(0.6), radius: 8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3), value: isVisible2)


                            VStack(alignment: .leading) {
                                Text("""
                                Welcome to **Command Quest**! 🖥️🎮
                                This is an **educational adventure game** designed to teach you **Unix/Linux terminal commands** in an **interactive and fun way**.
                                """)
                                .font(.system(size: 28))
                                .foregroundColor(Color(hex: "#00E6FF"))
                                .foregroundColor(Color(hex: "#E0E0E0"))
                                .lineSpacing(6)
                            }
                        }
                        .padding(.horizontal)

                        SectionView(icon: "play.circle.fill", title: "📖 HOW TO PLAY", description: """
                        - Each level presents a task related to Unix commands.
                        - Your goal: find and execute the correct command.
                        - If you get stuck, hints will appear automatically! 💡
                        """)

                        SectionView(icon: "map.fill", title: "🕹️ NAVIGATION", description: """
                        - Level Select → Select the level of your election.
                        - Level View → Type commands, check hints, complete tasks.
                        - Easter Eggs → Try different commands for surprises! 🎉
                        """)

                        SectionView(icon: "flag.fill", title: "🎯 LEVEL OBJECTIVES", description: """
                        - Learn and master Unix/Linux commands.
                        - Use commands like ls, cd, rm, cp, and more.
                        - Advanced levels introduce permissions (`chmod`).
                        """)

                        SectionView(icon: "gift.fill", title: "🥚 EASTER EGGS", description: """
                        - We’ve hidden fun and unexpected surprises throughout the game. 🕵️‍♂️
                        - Try different Unix commands to unlock hidden messages and jokes.
                        """)

                        SectionView(icon: "lightbulb.fill", title: "💡 USEFUL TIPS", description: """
                        - Read each task carefully before entering a command.
                        - Use man + [command] to learn more about any command.
                        - Use clear to clean up the screen.
                        """)
                        
                        SectionView(icon: "ipad", title: "📱 BEST VIEWING EXPERIENCE", description: """
                        - You can use the app in vertical mode, but for the best experience, it's recommended to use horizontal mode.
                        - Rotate your device for a wider and more comfortable interface.
                        """)

                        SectionView(icon: "info.circle.fill", title: "🎨 CREDITS", description: """
                        - Some icons used are free resources from design platforms.
                        - Sound effects and music are either public domain or original iOS assets.
                        - No copyrighted material is used.
                        """)
                        
                        SectionView(icon: "speaker.slash.fill", title: "🔊 AUDIO TROUBLESHOOTING", description: """
                        - If the audio appears stuck (e.g., the audio icon is visible but muted, or vice versa), simply tap the button again.
                        - This should refresh the audio and restore functionality.
                        - If the issue persists, try restarting the app.
                        """)
                        
                        HStack(spacing: 20) {
                                                    Image("ed")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 120, height: 120)
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color(hex: "#78FF00"), lineWidth: 4))
                                                        .shadow(radius: 10)
                                                    
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        Text("About the Creator")
                                                            .bold()
                                                            .foregroundColor(Color(hex: "#78FF00"))
                                                            .font(.title2)

                                                        Text("José Eduardo Orozco Cárdenas")
                                                            .bold()
                                                            .foregroundColor(Color(hex: "#78FF00"))

                                                        Text("A recent graduate and member of the ")
                                                            .foregroundColor(Color(hex: "#00E6FF")) +
                                                        Text("Community Change Makers of Enactus Mexico.")
                                                            .bold()
                                                            .foregroundColor(Color(hex: "#78FF00"))
                                                    }
                                                }
                                                .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 12) {
                                                    Text("📌 Background")
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(Color(hex: "#78FF00"))
                                                    
                                                    Text("Through the iOS Development Lab at my university (Universidad Autónoma de Chiapas), I learned to code apps for iOS, iPadOS, and other Apple products.")
                                                        .foregroundColor(Color(hex: "#00E6FF"))
                                                    
                                                    Text("This is my third and final attempt applying for the Swift Student Challenge, as I have now completed my professional studies.")
                                                        .foregroundColor(Color(hex: "#00E6FF"))
                                                    
                                                    Text("🕹️ Command Quest Inspiration")
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(Color(hex: "#78FF00"))
                                                    
                                                    Text("Command Quest was born from the realization that early-semester students often struggle when first introduced to Unix-based command-line interfaces like Linux distributions or macOS.")
                                                        .foregroundColor(Color(hex: "#00E6FF"))
                                                    
                                                    Text("To make learning these commands more engaging, intuitive, and visually appealing, I decided to create Command Quest—a game that helps fellow students learn in a more interactive way.")
                                                        .foregroundColor(Color(hex: "#00E6FF"))
                                                }
                                                .font(.system(size: 22))
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 20)


                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigation.goBack()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Return to Home")
                    }
                    .font(.title3)
                    .foregroundColor(Color(hex: "#78FF00"))
                }
            }
        }
    }
}

struct SectionView: View {
    let icon: String
    let title: String
    let description: String
    
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#78FF00")) // Verde neón
                .font(.system(size: 50))
                .scaleEffect(isVisible ? 1.1 : 0.9)
                .shadow(color: Color(hex: "#78FF00").opacity(0.6), radius: 8)
                .animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3), value: isVisible)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(Color(hex: "#78FF00")) // Verde neón
                    .opacity(isVisible ? 1 : 0)
                    .shadow(color: Color(hex: "#78FF00").opacity(0.4), radius: 5)
                    .animation(.easeInOut(duration: 0.6).delay(0.2), value: isVisible)

                Text(description)
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#00E6FF")) // Azul eléctrico
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: isVisible)
            }
        }
        .padding(.top, 20)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}
