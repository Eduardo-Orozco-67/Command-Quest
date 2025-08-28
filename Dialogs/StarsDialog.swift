import SwiftUI

struct StarsDialogExpandable: View {
    @State private var currentDialog = 0
    @State private var isValidated = false
    @Binding var currentContentIndex: Int
    @Binding var dialogOpacity: Double
    
    let dialogs: [Text] = [
        Text("Welcome to the mission, command explorer!").foregroundColor(Color(hex: "#00E6FF")),
        Text("In this adventure, you must master the use of ").foregroundColor(Color(hex: "#78FF00")) +
        Text("terminal commands").bold().foregroundColor(Color(hex: "#00E6FF")) +
        Text(" to navigate and execute tasks.").foregroundColor(Color(hex: "#78FF00")),
        Text("Your mission is to identify the correct commands hidden").foregroundColor(Color(hex: "#00E6FF")) +
        Text(" among the lost ones in space").foregroundColor(Color(hex: "#78FF00")) +
        Text(". Can you find them all?").foregroundColor(Color(hex: "#00E6FF")),
        Text("Get ready to put your terminal skills to the test!").foregroundColor(Color(hex: "#78FF00")),
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
            .rotationEffect(.degrees(currentContentIndex == 4 ? 45 : 0))
            .offset(y: currentContentIndex == 4 ? -UIScreen.main.bounds.height / 1 : 0)
            .animation(currentContentIndex == 4 ? .easeInOut(duration: 2) : .default, value: currentContentIndex)

            HStack(alignment: .center, spacing: 550) {
                // Previous arrow
                arrowButton(imageName: currentDialog == 0 ? "arrow.dis.p" : "arrow.act.a", isDisabled: currentDialog == 0, rotationDegrees: 180, offset: currentContentIndex == 4 ? -UIScreen.main.bounds.width / 1 : 0) {
                    if currentDialog > 0 {
                        withAnimation {
                            currentDialog -= 1
                            currentContentIndex = currentDialog
                        }
                    }
                }

                // Next arrow
                arrowButton(imageName: (currentDialog == dialogs.count - 1 || (currentDialog == 4 && !isValidated)) ? "arrow.dis.p" : "arrow.act.a", isDisabled: currentDialog == dialogs.count - 1 || (currentDialog == 4 && !isValidated), rotationDegrees: 0, offset: currentContentIndex == 4 ? UIScreen.main.bounds.width / 1 : 0) {
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
        .onChange(of: currentContentIndex) { newIndex in
            if newIndex == 4 {
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

struct StarsDialog: View {
    var body: some View {
        StarsDialogExpandable(currentContentIndex: .constant(0), dialogOpacity: .constant(1.0))
            .padding()
    }
}

struct StarsDialog_Previews: PreviewProvider {
    static var previews: some View {
        StarsDialog()
    }
}


