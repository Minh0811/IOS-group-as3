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

struct GlobalSettingView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @State private var selectedMode: Int = 0

    var body: some View {

            VStack(spacing: 20) {
                Text("Dark Mode Settings")
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                    .font(.headline)

                Picker(selection: $selectedMode, label: Text("Mode")) {
                    Text("Light Mode").tag(0)
                        .foregroundColor(globalSettings.isDark ? Color.black : Color.white)
                    Text("Dark Mode").tag(1)
                        .foregroundColor(globalSettings.isDark ? Color.black : Color.white)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedMode) { newValue in
                    switch newValue {
                    case 1:
                        globalSettings.isDark = true
                    case 0:
                        globalSettings.isDark = false
                    default:
                        break
                    }
                }
            }
            .onAppear{
                selectedMode = globalSettings.isDark ? 1 : 0
            }
            .padding()
        }
    
}

struct GlobalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalSettingView()
            .environmentObject(GlobalSettings.shared)
    }
}

