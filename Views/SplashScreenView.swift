import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView().environmentObject(NavigationManager())
        } else {
            ZStack {
                Color(hex: "#0D0D0D").ignoresSafeArea()
                    .overlay(
                        Color(hex: "#5C2D91").opacity(0.15)
                            .blur(radius: 50)
                            .edgesIgnoringSafeArea(.all)
                    )
                VStack {
                    VStack {
                        Image("cmicon")
                            .resizable()
                            .frame(width: 580, height:580)
                            .cornerRadius(30.0)

                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
