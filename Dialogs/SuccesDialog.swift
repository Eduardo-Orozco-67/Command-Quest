import SwiftUI

struct SuccessDialog: View {
    @Binding var nav: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(hex: "#0D0D0D")) // Fondo oscuro similar a la vista de instrucciones
                .frame(width: 700, height: 100)
                .shadow(color: Color(hex: "#78FF00").opacity(0.5), radius: 10)

            HStack {
                HStack(spacing: 8) {
                    Image("trophy-star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(hex: "#78FF00")) // Verde neón
                        .padding()
                    
                    Text("Adventure Completed!")
                        .foregroundColor(Color(hex: "#00E6FF")) // Azul cian brillante
                        .font(.custom("Montserrat", size: 22))
                        .bold()
                }
                .padding(.leading, 20)

                Spacer()

                // Botón de regreso al menú
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color(hex: "#5C2D91")) // Morado intenso
                    .frame(width: 365, height: 75)
                    .overlay(
                        HStack {
                            Text("To Continue Exploring, return to Menu")
                                .font(.custom("Montserrat", size: 20))
                                .bold()
                                .foregroundColor(Color(hex: "#78FF00")) // Verde neón
                        }
                    )
                    .onTapGesture {
                        nav = true
                    }
                    .padding(.trailing, 20)
            }
        }
        .frame(width: 500, height: 100)
        .onAppear {
            Task {
                await SoundManager.shared.playSound(named: "soundWin")
            }
        }
    }
}

struct SuccessDialog_Previews: PreviewProvider {
    static var previews: some View {
        let nav = Binding<Bool>(
            get: { return false },
            set: { _ in }
        )

        return SuccessDialog(nav: nav)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

