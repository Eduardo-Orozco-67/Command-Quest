import SwiftUI

struct InstruccionsDialogExpandable: View {
    @State private var currentDialog = 0
    @State private var isValidated = false
    @Binding var currentContentIndex: Int
    @Binding var dialogOpacity: Double

    let dialogs: [Text] = [ 
        Text("Welcome, Commander!").foregroundColor(Color(hex: "#00E6FF")),
        Text("In this mission, you will learn how to use ").foregroundColor(Color(hex: "#78FF00")) +
        Text("terminal commands").bold().foregroundColor(Color(hex: "#00E6FF")) +
        Text(" to navigate, manage files, and execute tasks.").foregroundColor(Color(hex: "#78FF00")),
        Text("To progress, enter the correct command for each challenge.").foregroundColor(Color(hex: "#00E6FF")) +
        Text(" If you make a mistake, don’t worry—you’ll receive hints to help you.").foregroundColor(Color(hex: "#78FF00")),
        Text("How to navigate:").bold().foregroundColor(Color(hex: "#00E6FF")),
        Text("- Type commands in the input field and press ").foregroundColor(Color(hex: "#78FF00")) +
        Text("Enter").bold().foregroundColor(Color(hex: "#00E6FF")) +
        Text(" to execute them.").foregroundColor(Color(hex: "#78FF00")),
        Text("- If you’re unsure about a command, pay attention to the hints that appear.").foregroundColor(Color(hex: "#00E6FF")),
        Text("- Use the ").foregroundColor(Color(hex: "#00E6FF")) +
        Text("Return Menu").bold().foregroundColor(Color(hex: "#78FF00")) +
        Text(" button to change levels at any time.").foregroundColor(Color(hex: "#00E6FF")),
        Text("- If you complete a level successfully, return to the menu to proceed to the next one!").foregroundColor(Color(hex: "#78FF00")),
        Text("- Your goal:").bold().foregroundColor(Color(hex: "#00E6FF")) +
        Text(" Solve all levels and master the terminal like a true command-line expert!").foregroundColor(Color(hex: "#78FF00")),
        Text("Remember, each challenge teaches you something new—don't give up!").foregroundColor(Color(hex: "#00E6FF")),
        Text("Are you ready? The adventure begins now!").foregroundColor(Color(hex: "#00E6FF")),
        Text(". . .").bold().foregroundColor(Color(hex: "#00E6FF")),
    ]

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image("astronaut")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                dialogs[currentDialog]
                    .font(.custom("Montserrat", size: 24))
                    .frame(width: 550)
            }
            .padding()
            .background(Color(hex: "#0D0D0D").opacity(0.9))
            .cornerRadius(20)
            .shadow(color: Color(hex: "#78FF00").opacity(0.4), radius: 20, x: 0, y: 0)
            .opacity(dialogOpacity)
            .rotationEffect(.degrees(currentDialog == 11 ? 45 : 0))
            .offset(y: currentDialog == 11 ? -UIScreen.main.bounds.height / 1 : 0)
            .animation(currentDialog == 11 ? .easeInOut(duration: 2) : .default, value: currentDialog)

            HStack(alignment: .center, spacing: 250) {
                // Flecha anterior
                arrowButton(imageName: currentDialog == 0 ? "arrow.dis.p" : "arrow.act.a", isDisabled: currentDialog == 0, rotationDegrees: 180, offset: currentDialog == 11 ? -UIScreen.main.bounds.width / 1 : 0) {
                    if currentDialog > 0 {
                        withAnimation {
                            currentDialog -= 1
                            currentContentIndex = currentDialog
                        }
                    }
                }
                
                Button(action: {
                       withAnimation(.easeInOut(duration: 2)) { // 🔹 Activa animaciones de salida
                           dialogOpacity = 0
                       }
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                           currentContentIndex = dialogs.count // 🔹 Salta al final
                       }
                   }) {
                       Text("Skip")
                           .font(.custom("Montserrat", size: 30))
                           .foregroundColor(Color(hex: "#78FF00"))
                           .padding(10)
                           .background(Color(hex:"0D0D0D").opacity(0.8))
                           .cornerRadius(10)
                           .shadow(color: Color(hex: "#78FF00").opacity(0.5), radius: 5, x: 0, y: 0)
                   }
                   .rotationEffect(.degrees(currentDialog == 11 || dialogOpacity == 0 ? 45 : 0)) // 🔹 Se inclina al salir
                   .offset(y: currentDialog == 11 || dialogOpacity == 0 ? UIScreen.main.bounds.height / 1.5 : 0) // 🔹 Se mueve fuera de pantalla
                   .opacity(dialogOpacity) // 🔹 Se desvanece gradualmente
                   .animation(.easeInOut(duration: 2), value: dialogOpacity)


                // Flecha siguiente (Solo cambia si llega a 10)
                arrowButton(imageName: (currentDialog == dialogs.count - 1 || (currentDialog == 11 && !isValidated)) ? "arrow.dis.p" : "arrow.act.a", isDisabled: currentDialog == dialogs.count - 1 || (currentDialog == 11 && !isValidated), rotationDegrees: 0, offset: currentDialog == 11 ? UIScreen.main.bounds.width / 1 : 0) {
                    if currentDialog < dialogs.count - 1 {
                        withAnimation {
                            currentDialog += 1
                            currentContentIndex = currentDialog
                        }
                    }
                }
            }
            .padding()
            .opacity(dialogOpacity)
        }
        .onChange(of: currentDialog) { newIndex in
            if newIndex == 11 { // Se cambia la condición a 10
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    withAnimation(.easeOut(duration: 2)) {
                        dialogOpacity = 0
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func arrowButton(imageName: String, isDisabled: Bool, rotationDegrees: Double, offset x: CGFloat, action: @escaping () -> Void) -> some View {
        ZStack {
            Circle()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .offset(x: 3)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .offset(x: x)
        .disabled(isDisabled)
        .onTapGesture(perform: action)
    }
}

struct InstruccionsDialog: View {
    var body: some View {
        InstruccionsDialogExpandable(currentContentIndex: .constant(0), dialogOpacity: .constant(1.0))
            .padding()
    }
}

struct InstruccionsDialog_Previews: PreviewProvider {
    static var previews: some View {
        InstruccionsDialog()
    }
}
