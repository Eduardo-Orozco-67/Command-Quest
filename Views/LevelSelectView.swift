import SwiftUI

struct LevelSelectView: View {
    @EnvironmentObject var navigation: NavigationManager
    @State private var selectedIndex = 0
    @State private var showInstructions = true  //Controls when to show instructions
    @State private var dialogOpacity = 1.0
    @State private var currentContentIndex = 0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let levels: [Levelq] = [
        Levelq(number: 1, command: "LEVEL 1"),
        Levelq(number: 2, command: "LEVEL 2"),
        Levelq(number: 3, command: "LEVEL 3"),
        Levelq(number: 4, command: "LEVEL 4"),
        Levelq(number: 5, command: "LEVEL 5"),
        Levelq(number: 6, command: "LEVEL 6"),
        Levelq(number: 7, command: "LEVEL 7"),
        Levelq(number: 8, command: "LEVEL 8"),
        Levelq(number: 9, command: "LEVEL 9"),
        Levelq(number: 10, command: "LEVEL 10"),
        Levelq(number: 0, command: "MINI GAME")
        
    ]
    
    let command: [Commandw] = [
        Commandw(commandtype: "This command is used to list\n    files and directories"), // ls
        Commandw(commandtype: " This command allows you to\nnavigate between directories"), // cd
        Commandw(commandtype: "This command creates an\n       empty file"), // touch
        Commandw(commandtype: "This command deletes a file"), // rm
        Commandw(commandtype: "This command copies a\n  file or directory"), // cp
        Commandw(commandtype: "This command moves or\n    renames a file"), // mv
        Commandw(commandtype: "This command displays the\n    contents of a file"), // cat
        Commandw(commandtype: "This command creates a\n     new directory"), // mkdir
        Commandw(commandtype: "This command removes an\n    empty directory"), // rmdir
        Commandw(commandtype: "This command modifies\n   file permissions"),
        Commandw(commandtype: "This is a mini game to find\ncommands losing in the stars")// chmod
    ]



    var body: some View {
        ZStack {
            Color(hex: "#0D0D0D").ignoresSafeArea()
                .overlay(
                    Color(hex: "#5C2D91").opacity(0.15)
                        .blur(radius: 50)
                        .edgesIgnoringSafeArea(.all)
                )
            
            if showInstructions {
                            InstruccionsDialogExpandable(
                                currentContentIndex: $currentContentIndex,
                                dialogOpacity: $dialogOpacity
                            )
                            .transition(.opacity)
                            .onChange(of: dialogOpacity) { newValue in
                                if newValue == 0 {
                                    withAnimation {
                                        showInstructions = false
                                    }
                                }
                            }
                        } else {
            VStack(spacing: 5) {
                Text(horizontalSizeClass == .compact ? "CHOOSE A LEVEL\nTO LEARN OR PRACTICE" : "CHOOSE A LEVEL TO LEARN OR PRACTICE")
                            .font(.system(size: 50, weight: .heavy, design: .monospaced))
                            .foregroundColor(Color(hex: "#78FF00"))
                            .shadow(color: Color(hex: "#78FF00").opacity(0.8), radius: 10, x: 0, y: 0)
                            .overlay(
                                Text(horizontalSizeClass == .compact ? "CHOOSE A LEVEL\nTO LEARN OR PRACTICE" : "CHOOSE A LEVEL TO LEARN OR PRACTICE")
                                    .font(.system(size: 50, weight: .heavy, design: .monospaced))
                                    .foregroundColor(Color(hex: "#78FF00").opacity(0.6))
                                    .blur(radius: 3)
                            )
                            .padding(.top, 25)
                            .multilineTextAlignment(.center)

                
                TabView(selection: $selectedIndex) {
                    ForEach(0..<levels.count, id: \.self) { index in
                        LevelCardView(
                            level: levels[index],
                            command: command[index],
                            isSelected: selectedIndex == index,
                            onSelect: {
                                navigation.navigate(to: .level(levels[index]))
                            }
                        )
                        .rotationEffect(.degrees(selectedIndex == index ? 0 : -5))
                        .scaleEffect(selectedIndex == index ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: selectedIndex)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: selectedIndex) { _ in
                    Task {
                        await SoundManager.shared.playSound(named:"desplazarSound") // 🔊 Sonido al cambiar tarjeta
                    }
                }

                
                HStack(spacing: 25) {
                    ForEach(0..<levels.count, id: \ .self) { index in
                        ZStack {
                            Circle()
                                .stroke(lineWidth: selectedIndex == index ? 4 : 2)
                                .frame(width: selectedIndex == index ? 44 : 22, height: selectedIndex == index ? 44 : 22)
                                .foregroundColor(Color(hex: "#78FF00"))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        selectedIndex = index
                                    }
                                }
                            
                            if selectedIndex == index {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "#5C2D91"))
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        }
        .navigationBarTitleDisplayMode(.inline)
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

struct LevelCardView: View {
    let level: Levelq
    let command: Commandw
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.35))
                .frame(width: isSelected ? 620 : 580, height: isSelected ? 420 : 380)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: isSelected ? [Color(hex: "#78FF00"), Color(hex: "#5C2D91")] : [Color(hex: "#78FF00").opacity(0.6), Color.mint.opacity(0.6)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: isSelected ? 7 : 5
                        )
                )
                .shadow(color: Color(hex: "#78FF00").opacity(0.5), radius: 7, x: 0, y: 0)
                .onTapGesture {
                    Task {
                        await SoundManager.shared.playSound(named: "nA")
                    }
                    onSelect()
                }
            
            VStack(spacing: 8) {
                GlitchRGBText(text: level.command.uppercased())
                    .font(.system(size: isSelected ? 100 : 80, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 3, x: 0, y: 0)

                Text(command.commandtype)
                    .font(.system(size: 30, weight: .heavy, design: .monospaced))
                    .foregroundColor(Color(hex: "#78FF00"))
                    .shadow(color: Color(hex: "#78FF00").opacity(0.8), radius: 10, x: 0, y: 0)
                    .overlay(
                        Text(command.commandtype)
                            .font(.system(size: 30, weight: .heavy, design: .monospaced))
                            .foregroundColor(Color(hex: "#78FF00").opacity(0.6))
                            .blur(radius: 3)
                    )
            }
        }
        .animation(.easeInOut(duration: 0.9), value: isSelected)
    }
}

struct GlitchRGBText: View {
    let text: String
    @State private var glitchOffsetX: CGFloat = 0
    @State private var glitchOffsetY: CGFloat = 0
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            Text(text)
                .foregroundColor(.red.opacity(0.8))
                .offset(x: glitchOffsetX, y: glitchOffsetY)
                .rotationEffect(.degrees(rotationAngle))

            Text(text)
                .foregroundColor(.blue.opacity(0.8))
                .offset(x: -glitchOffsetX, y: -glitchOffsetY)
                .rotationEffect(.degrees(-rotationAngle))

            Text(text)
                .foregroundColor(.green)
        }
        .onAppear {
            startGlitchEffect()
        }
    }

    private func startGlitchEffect() {
        Task {
            while true {
                await MainActor.run {
                    glitchOffsetX = CGFloat.random(in: -4...4)
                    glitchOffsetY = CGFloat.random(in: -4...4)
                    rotationAngle = Double.random(in: -2...2)
                }
                try? await Task.sleep(nanoseconds: UInt64(0.08 * 1_000_000_000))
            }
        }
    }
}


struct LevelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectView().environmentObject(NavigationManager())
    }
}
