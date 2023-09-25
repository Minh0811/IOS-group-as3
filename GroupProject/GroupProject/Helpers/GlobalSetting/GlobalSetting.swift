/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 10/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation
import SwiftUI

class GlobalSettings: ObservableObject {

   
    
       static let shared = GlobalSettings()
    
    @Published var isDark: Bool = false
    @Published var iphone14ProBaseWidth: CGFloat = 393
    
    private init() {}
}
