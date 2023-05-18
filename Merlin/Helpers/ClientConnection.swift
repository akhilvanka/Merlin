//
//  ClientConnection.swift
//  Merlin
//
//  Created by Akhil Vanka on 5/15/23.
//

import Foundation
import Network
import Combine

class ClientConnection: ObservableObject {
    public var messageResponse: String!
    let nwConnection: NWConnection
    let queue = DispatchQueue(label: "Client connection Q")

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        nwConnection.stateUpdateHandler = stateDidChange(to:)
//        setupReceive()
        nwConnection.start(queue: queue)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
//        case .ready:
////            print("Client connection ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        var message = ""
        nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                message = String(data: data, encoding: .utf8) ?? ""
//                print("\(message)")
                  DispatchQueue.main.async {
                      self.messageResponse = message
                  }
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }
    func receiveResponse() {
        nwConnection.receiveMessage { (data, context, isComplete, error) in
            if let error = error {
                print(error)
            }
            if let data = data, !data.isEmpty {
                let backToString = String(decoding: data, as: UTF8.self)
                print(backToString)
            }
        }
    }
    
//    func receiveResponse() -> String {
//        return self.messageResponse
//    }
    
    func send(data: Data) {
        nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
        }))
    }

    private func connectionDidFail(error: Error) {
        self.stop()
    }

    private func connectionDidEnd() {
        self.stop()
    }

    func stop() {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
    }
}
