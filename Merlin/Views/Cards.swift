//
//  Cards.swift
//  Merlin
//
//  Created by Akhil Vanka on 5/11/23.
//

import Foundation
import SwiftUI
import Network

struct CalenderView: View {
    @Binding var queryIP: String
    @Binding var isSelected: Bool
    @State private var wing: Int = 500
    @StateObject var queryArray = QueryArray(start: 51, end: 78)
    @State var queryRoom: String = ""
    let timer = Timer.publish(every: 120, tolerance: 60, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 25, style:.continuous)
                    .fill(Color.offWhite)
                    .frame(width: UIScreen.screenWidth, height: UIDevice().checkIfHasDynamicIsland() ? UIScreen.screenHeight/3.5: UIScreen.screenHeight/3.7)
                    .padding([.leading, .bottom, .trailing])
                Spacer()
            }
            .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(wing) Wing")
                        .font(.title)
                        .bold()
                        .padding(.leading)
                        .foregroundColor(Color.darkGrey)
                    Menu {
                        Picker(selection: $wing, label:Text("Wing:")) {
                            Text("300").tag(300)
                            Text("400").tag(400)
                            Text("500").tag(500)
                            Text("600").tag(600)
                            Text("700").tag(700)
                        }
                        .onChange(of: wing) { num in
                            changeRegion(wing: num)
                        }
                    } label: {
                        Label("\(wing) Wing", systemImage: "chevron.down.circle")
                            .labelStyle(.iconOnly)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.darkGrey)
                    }
                    Spacer()
                }
                .padding(.all)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        if queryArray.fetchRoom().isEmpty == true {
                            Text("No Devices")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: UIScreen.screenWidth-30, height: UIScreen.screenHeight/10)
                                .background(RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color.white))
                        } else {
                            ForEach(queryArray.fetchRoom(), id:\.self) { ip in
                                Button(action: {
                                    queryIP = queryArray.fetchIP(room: ip);
                                    queryRoom = ip.trimmingCharacters(in: .whitespacesAndNewlines);
                                    isSelected = true
                                }) {
                                    Text("\(ip.trimmingCharacters(in: .whitespacesAndNewlines))")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(nil)
                                        .foregroundColor(.black)
                                        .frame(width: UIScreen.screenHeight/8.75, height: UIScreen.screenHeight/10, alignment: .center)
                                        .background(RoundedRectangle(cornerRadius: 25, style: .continuous).fill(queryRoom == ip.trimmingCharacters(in: .whitespacesAndNewlines) && isSelected ? Color.goldBronze: Color.white))
                                }
                            }
                        }
                    }.padding(.horizontal)
                        .onReceive(timer) { time in
                            changeRegion(wing: wing)
                        }
                }
                .padding([.leading, .bottom, .trailing])
                Spacer()
            }
        }
    }
    func changeRegion(wing: Int) {
        switch wing {
        case 300:
            queryArray.update(start: 31, end: 38)
        case 400:
            queryArray.update(start: 42, end: 50)
        case 500:
            queryArray.update(start: 51, end: 78)
        case 600:
            queryArray.update(start: 79, end: 90)
        case 700:
            queryArray.update(start: 91, end: 112)
        default:
            queryArray.update(start: 1, end: 254)
        }
    }
}



struct CardView_Previews: PreviewProvider {
    @State static var selectedIP = ""
    @State static var isSelected = false
    static var previews: some View {
        CalenderView(queryIP: self.$selectedIP, isSelected: self.$isSelected)
    }
}

extension UIDevice {
    func checkIfHasDynamicIsland() -> Bool {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            let nameSimulator = simulatorModelIdentifier
            return nameSimulator == "iPhone15,2" || nameSimulator == "iPhone15,3" ? true : false
        }
        
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let name =  String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return name == "iPhone15,2" || name == "iPhone15,3" ? true : false
    }
}
