import Foundation

//PASS oauth:vvdaqv83axufdgrp642d6z2ymg4apy
//NICK d1mka112

//if PING :tmi.twitch.tv
//send PONG :tmi.twitch.tv


class MyWebSocket
{
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://irc-ws.chat.twitch.tv:443")!)
    func connectToTheChat()
    {
        webSocketTask.resume()
        self.sendMessage(message: "PASS oauth:vvdaqv83axufdgrp642d6z2ymg4apy")
        self.sendMessage(message: "NICK d1mka112")
        print("message sended")
    }
    func joinIntoChannel(_ channel: String)
    {
        self.sendMessage(message: "JOIN #\(channel)")
    }
    func sendMessage(message: String)
    {
        let urlMessage = URLSessionWebSocketTask.Message.string(message)
        
        webSocketTask.send(urlMessage) { error in
            if error != nil {
                print("WebSocket Couldn't send message \(error!)")
            }
        }
    }
    func readMessage()
    {
        webSocketTask.receive { (result) in
            switch result {
                case .success(let urlMessage):
                    switch urlMessage {
                        case .string(let message):
                            print(message)
                        default:
                            print("error message")
                            return
                    }
                case .failure(let error):
                    print(error)
                
            }
        }
    }
}

let myWebSocket = MyWebSocket()

myWebSocket.connectToTheChat()
myWebSocket.readMessage()
myWebSocket.joinIntoChannel("buster")

for i in 1...1000 {
    myWebSocket.readMessage()
}

