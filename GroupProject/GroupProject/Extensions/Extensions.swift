/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 21/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/


import SwiftUI

extension View {
    //@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    //.customBackButton(presentationMode: presentationMode)
    /// Provides a custom back button for a navigation view.
    ///
    /// This function replaces the default back button with a custom-designed button.
    /// The custom button is a black rectangle with a white "multiply square" symbol.
    ///
    /// - Parameter presentationMode: A binding to the presentation mode of the view.
    /// - Returns: The view with the custom back button.
    func customBackButton(presentationMode: Binding<PresentationMode>) -> some View {
        self
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) { // Place the custom button on the leading side of the navigation bar
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the current view when the button is tapped
                    }, label: {
                        ZStack{
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40) // Set the size of the rectangle
                            Image(systemName: "multiply.square.fill") // Use the "multiply square" symbol
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                    })
                }
            })
    }
}
