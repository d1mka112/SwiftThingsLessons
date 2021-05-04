import Foundation
//SSH connect

//PASS oauth:vvdaqv83axufdgrp642d6z2ymg4apy
//NICK d1mka112

//if PING :tmi.twitch.tv
//send PONG :tmi.twitch.tv

protocol MyWebSocketDelegate {
    func onMessage(message: String)
}

struct TwitchChatMessage {
    let nickname: String
    let message: String
    
    init(nickname:String, message: String) {
        self.nickname = nickname
        self.message = message
    }
}

class MyWebSocket
{
    let nickname: String = "d1mka112"
    let token: String = "oauth:vvdaqv83axufdgrp642d6z2ymg4apy"
    
    var delegate: MyWebSocketDelegate?
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://irc-ws.chat.twitch.tv:443")!)
    func connectToTheChat() {
        webSocketTask.resume()
        self.sendMessage(message: "PASS \(token)")
        self.sendMessage(message: "NICK \(nickname.lowercased())")
        print("message sended")
    }
    func joinToTheChannel(_ channel: String) {
        self.sendMessage(message: "JOIN #\(channel)")
    }
    func sendMessage(message: String) {
        let urlMessage = URLSessionWebSocketTask.Message.string(message)
        
        webSocketTask.send(urlMessage) { error in
            if error != nil {
                print("WebSocket Couldn't send message \(error!)")
            }
        }
    }
    func readMessage() {
        for i in 1...100 {
            webSocketTask.receive { (result) in
                switch result {
                    case .success(let urlMessage):
                        switch urlMessage {
                            case .string(let message):
                                self.delegate?.onMessage(message: message)
                            default:
                                print("Error of reading message")
                                return
                        }
                    case .failure(let error):
                        print(error)
                    
                }
            }
        }
    }
}


class TwitchReader: MyWebSocketDelegate {
    func onMessage(message: String) {
        let twitchChatMessage = self.getTwitchChatMessage(from: message)
        print("\(twitchChatMessage.nickname) : \(twitchChatMessage.message)")
    }
    
    func getTwitchChatMessage(from message: String) -> TwitchChatMessage{
        var name = ""
        var messageString = ""
        if let index = message.firstIndex(of: "!") {
            name = String(message.prefix(upTo: index).dropFirst())
        }
        if let index1 = message.firstIndex(of: "#") {
            if let index2 = message.suffix(from: index1).firstIndex(of: ":") {
                messageString = String(message.suffix(from: index2).dropFirst())
            }
        }
        let twitchChatMessage = TwitchChatMessage(nickname: name, message: messageString)
        return twitchChatMessage
    }
}

let myWebSocket = MyWebSocket()
let myReader = TwitchReader()
myWebSocket.delegate = myReader

myWebSocket.connectToTheChat()

myWebSocket.joinToTheChannel("jesusavgn")
myWebSocket.readMessage()


