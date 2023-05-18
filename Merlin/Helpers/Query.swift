//
//  Query.swift
//  Merlin
//
//  Created by Akhil Vanka on 5/11/23.
//

import Foundation
import Network

struct Projector {
    var roomNumber: String
    var ipAddress: String
}

class QueryArray: ObservableObject {
    @Published var queryArray = [String:String]()
    
    init(start: Int, end: Int){
        for i in start...end {
            let once = try? SwiftyPing(host: "10.3.112.\(i)", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            once?.observer = { (response) in
                if response.error == nil {
//                    self.queryArray.append("10.3.112.\(i)")
                    let client = Client(host: "10.3.112.\(i)", port: 4352)
                    client.start()
                    client.receive()
                    client.connection.send(data: ("%1NAME ?\r".data(using: .utf8))!)
                    var foo: String {
                        let semaphore = DispatchSemaphore(value: 0)
                        var string = ""

                        client.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { 
                            (data, _, isComplete, error) in
                                if let data = data, !data.isEmpty {
                                    string = String(data: data, encoding: .utf8) ?? ""
                                    semaphore.signal()
                                }
                        }

                        semaphore.wait()
                        return string
                    }
//                    print("10.3.112.\(i): \(foo)")
                    self.queryArray[String(foo.dropFirst(9))] = "10.3.112.\(i)"
//                    self.queryArray.append(foo)
//                    print(self.queryArray)
                }
            }
            once?.targetCount = 1
            try? once?.startPinging()
        }
    }
    func fetchRoom() -> [String] {
        let roomNumber = Array(queryArray.keys)
//        return self.queryArray
        return roomNumber
    }
    func fetchIP(room:String) -> String {
        return queryArray[room] ?? ""
    }
    func update(start: Int, end: Int) {
        queryArray.removeAll()
        for i in start...end {
            let once = try? SwiftyPing(host: "10.3.112.\(i)", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            once?.observer = { (response) in
                if response.error == nil {
//                    self.queryArray.append("10.3.112.\(i)")
                    let client = Client(host: "10.3.112.\(i)", port: 4352)
                    client.start()
                    client.receive()
                    client.connection.send(data: ("%1NAME ?\r".data(using: .utf8))!)
                    var foo: String {
                        let semaphore = DispatchSemaphore(value: 0)
                        var string = ""

                        client.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) {
                            (data, _, isComplete, error) in
                                if let data = data, !data.isEmpty {
                                    string = String(data: data, encoding: .utf8) ?? ""
                                    semaphore.signal()
                                }
                        }

                        semaphore.wait()
                        return string.replacingOccurrences(of: "\r", with: "")
                    }
//                    print("10.3.112.\(i): \(foo)")
//                    self.queryArray.append(foo)
                    self.queryArray[String(foo.dropFirst(9))] = "10.3.112.\(i)"
                }
            }
            once?.targetCount = 1
            try? once?.startPinging()
        }
    }
}


class ProjectorArray: ObservableObject {
    @Published var projectorArray: [Projector] = []
    
    init(start: Int, end: Int){
        for i in start...end {
            let once = try? SwiftyPing(host: "10.3.112.\(i)", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            once?.observer = { (response) in
                if response.error == nil {
                    let client = Client(host: "10.3.112.\(i)", port: 4352)
                    client.start()
                    client.receive()
                    client.connection.send(data: ("%1NAME ?\r".data(using: .utf8))!)
                    var foo: String {
                        let semaphore = DispatchSemaphore(value: 0)
                        var string = ""

                        client.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) {
                            (data, _, isComplete, error) in
                                if let data = data, !data.isEmpty {
                                    string = String(data: data, encoding: .utf8) ?? ""
                                    semaphore.signal()
                                }
                        }

                        semaphore.wait()
                        return string
                    }
                    print("10.3.112.\(i): \(foo.dropFirst(9))")
                    let name = Projector(roomNumber: foo, ipAddress: "10.3.112.\(i)")
                    self.projectorArray.append(name)
//                    self.projectorArray.append(Projector(roomNumber: foo, ipAddress: "10.3.112.\(i)"))
                }
            }
            once?.targetCount = 1
            try? once?.startPinging()
        }
    }
    func fetch() -> [Projector] {
//        print(self.projectorArray)
        return self.projectorArray
    }
    func update(start: Int, end: Int) {
        projectorArray = []
        for i in start...end {
            let once = try? SwiftyPing(host: "10.3.112.\(i)", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            once?.observer = { (response) in
                if response.error == nil {
                    let client = Client(host: "10.3.112.\(i)", port: 4352)
                    client.start()
                    client.receive()
                    client.connection.send(data: ("%1NAME ?\r".data(using: .utf8))!)
                    var foo: String {
                        let semaphore = DispatchSemaphore(value: 0)
                        var string = ""

                        client.nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) {
                            (data, _, isComplete, error) in
                                if let data = data, !data.isEmpty {
                                    string = String(data: data, encoding: .utf8) ?? ""
                                    semaphore.signal()
                                }
                        }

                        semaphore.wait()
                        return string
                    }
                    print("10.3.112.\(i): \(foo.dropFirst(9))")
                    self.projectorArray.append(Projector(roomNumber: foo, ipAddress: "10.3.112.\(i)"))
                }
            }
            once?.targetCount = 1
            try? once?.startPinging()
        }
    }
}
