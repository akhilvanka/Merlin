//
//  RemoteView.swift
//  Merlin
//
//  Created by Akhil Vanka on 5/14/23.
//

import SwiftUI
import Network

struct RemoteView: View {
    @Binding var isVisible:Bool
    @Binding var selectedIP: String
    
    var body: some View {
        VStack {
            if isVisible {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.darkBlack)
                    .frame(width: UIScreen.screenWidth-40, height: UIScreen.screenHeight/1.6)
                    .padding(.all)
                    .onTapGesture {
                        sendOff(name: selectedIP)
                    }
            }
        }
    }
    func sendOff(name: String) {
        let client = Client(host: name, port: 4352)
        client.start()
        client.connection.send(data: ("%1POWR 0\r".data(using: .utf8))!)
        isVisible = false
        selectedIP = ""
    }
    func sendVMute(name: String) {
        let client = Client(host: name, port: 4352)
        client.start()
        client.connection.send(data: ("%1AVMT 11\r".data(using: .utf8))!)
        print("Hi")
    }
    func sendOffMute(name: String) {
        let client = Client(host: name, port: 4352)
        client.start()
        client.connection.send(data: ("%1AVMT 30\r".data(using: .utf8))!)
    }
    func sendAMute(name: String) {
        let client = Client(host: name, port: 4352)
        client.start()
        client.connection.send(data: ("%1AVMT 21\r".data(using: .utf8))!)
    }
}

struct RemoteView_Previews: PreviewProvider {
    @State static var isVisible = true
    @State static var selectedIP = ""
    static var previews: some View {
        RemoteView(isVisible: self.$isVisible, selectedIP: self.$selectedIP)
    }
}
