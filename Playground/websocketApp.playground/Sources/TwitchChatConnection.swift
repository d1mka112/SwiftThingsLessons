import Foundation
/*TODO:
 - add onServerMessage()
 - add onChatMessage()
 - add onJoinChannel()
*/


struct TwitchChatMessage {
    var nickname: String
    var message: String
    var rawMessage: String
    
    init(rawMessage: String) {
        self.nickname = ""
        self.message = ""
        if let index = rawMessage.firstIndex(of: "!") {
            self.nickname = String(rawMessage.prefix(upTo: index).dropFirst())
        }
        if let index1 = rawMessage.firstIndex(of: "#") {
            if let index2 = rawMessage.suffix(from: index1).firstIndex(of: ":") {
                self.message = String(rawMessage.suffix(from: index2).dropFirst())
            }
        }
        self.rawMessage = rawMessage
    }
}

class TwitchChatConnection {
    
    var nickname: String = "d1mka112"
    var token: String = "oauth:vvdaqv83axufdgrp642d6z2ymg4apy"
    
    var channel: String = ""
    
    var webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://irc-ws.chat.twitch.tv:443")!)
    
    func sendMessage(message: String) {
        let urlMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(urlMessage) { error in
            if error != nil {
                print("WebSocket Couldn't send message \(error!)")
            }
        }
    }
    
    func connectToTheServer() {
        webSocketTask.resume()
        self.sendMessage(message: "PASS \(token)")
        self.sendMessage(message: "NICK \(nickname.lowercased())")
    }
    func connectToTheChatChannel(into channel: String) {
        self.sendMessage(message: "JOIN #\(channel)")
    }
    
    func sendMessageToTheChat(message: String) {
        if channel != "" {
            self.sendMessage(message: "PRIVMSG #\(channel) :\(message)")
        }
        else {
            print("You are not join to the channel!")
        }
    }
    
    func readMessage() {
        webSocketTask.receive { (result) in
            switch result {
                case .success(let urlMessage):
                    switch urlMessage {
                        case .string(let message):
                            print(message)
                            let chatMessage = TwitchChatMessage(rawMessage: message)
                            //self.delegate?.onMessage(message: message)
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
