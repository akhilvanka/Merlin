//
//  ContentView.swift
//  Merlin
//
//  Created by Akhil Vanka on 5/11/23.
//

import SwiftUI
import Foundation
import Network

struct ContentView: View {
    @State var name: String = ""
    @State var isSelected: Bool = false
    var body: some View {
        ZStack {
            Color.darkGrey
                .ignoresSafeArea()
            CalenderView(queryIP: self.$name, isSelected: self.$isSelected)
            VStack(alignment: .center) {
                Spacer()
                RemoteView(isVisible: self.$isSelected, selectedIP: self.$name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension Color {
    static let offWhite = Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)
    static let darkGrey = Color("darkGrey")
    static let goldBronze = Color("AccentColor")
    static let darkBlack = Color(red: 38/255, green: 38/255, blue: 38/255)
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
