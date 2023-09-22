//
//  GlobalSetting.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 21/09/2023.
//

import Foundation
import SwiftUI

class GlobalSettings: ObservableObject {

   
    
    static let shared = GlobalSettings()
    
    @Published var isDark: Bool = false
      
    private init() {}
}
