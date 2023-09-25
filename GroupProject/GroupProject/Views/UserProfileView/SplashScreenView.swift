/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 21/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var appState = AppState()
    @State private var isSplashScreenComplete = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isSplashScreenComplete {
            
            AuthenticationView()
                .environmentObject(appState)
            
        } else {
            ZStack {
                Image("theme")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack {
                        // Your splash screen content here
                        VStack{
                            Image("green")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 80))
                                .foregroundColor(.red)
                                .frame(width: 210, height: 210)
                                .clipShape(Circle())
                        }.background(Color("Color"))
                            .clipShape(Circle())
                        
                        Text("Welcome to JourneyHub")
                            .font(Font.custom("Baskerville-Bold", size: 26))
                            .foregroundColor(.black.opacity(0.80))
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
                            self.isSplashScreenComplete = true
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
            .environmentObject(AppState()) // Add an instance of AppState here
    }
}
