//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Foundation
import Security

class MyViewController : UIViewController {
    
    var coinChain = blockChain()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Most recent block: \(coinChain.getLatestBlock())"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

class block {
    var addedString = String()
    var hash = String()
    var previousHash = String()
    var index = Int()
    var dateCreated = String()
    var amountTransfered = Int()
    
    init(index: Int, dateCreated: String, amountTransfered: Int, previousHash: String) {
        addedString = "\(index)\(dateCreated)\(amountTransfered)\(previousHash)"
        self.hash = calculateHash()
        self.previousHash = previousHash
        self.index = index
        self.dateCreated = dateCreated
        self.amountTransfered = amountTransfered
    }
    
    func calculateHash() -> String {
        var hashString = "\(addedString.hashValue)"
        hashString = hashString.replacingOccurrences(of: "-", with: "")
        return hashString
    }

}

class blockChain {
    //create genesis block
    var chain = [block(index: 0, dateCreated: "01/27/2018", amountTransfered: 0, previousHash: "0")]
    
    init() {
        print("initialized")
    }

    func getLatestBlock() -> block {
        return chain[Int(chain.count - 1)]
    }

    func addBlock(newBlock: block) {
        if newBlock.previousHash == getLatestBlock().hash {
            chain.append(newBlock)
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
