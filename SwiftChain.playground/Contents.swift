//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Foundation
import Security

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

class block {
    var addedString = String()
    var hash = String()
    init(index: Int, dateCreated: String, amountTransfered: Int, previousHash: String) {
        addedString = "\(index)\(dateCreated)\(amountTransfered)\(previousHash)"
        var hash = calculateHash()
    }
    
    func calculateHash() -> String {
        let hashString = "\(addedString.hashValue)"
        return hashString
    }

}

class blockChain {
    //create genesis block
    var chain = [block(index: 0, dateCreated: "01/23/2018", amountTransfered: 0, previousHash: "0")]
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
