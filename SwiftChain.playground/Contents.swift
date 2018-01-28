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

        let walletOverviewStatusView = CAGradientLayer()
        walletOverviewStatusView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height * 0.653 * 0.4)
        
        let walletTitleLabel = UILabel()
        walletTitleLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width*0.5, height: 50)
        walletTitleLabel.text = "SwiftChain"
        walletTitleLabel.textColor = .white
        walletTitleLabel.textAlignment = .center
        walletTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        let walletSubtitleLabel = UILabel()
        walletSubtitleLabel.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width*0.5, height: 20)
        walletSubtitleLabel.text = "Wallet"
        walletSubtitleLabel.textColor = .white
        walletSubtitleLabel.textAlignment = .center
        walletSubtitleLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        walletSubtitleLabel.layer.opacity = 0.6
        
        let walletBalance = UILabel()
        walletBalance.frame = CGRect(x: 0, y: walletOverviewStatusView.frame.height / 2, width: UIScreen.main.bounds.width*0.5, height: 50)
        walletBalance.text = "0.0 SXC"
        walletBalance.textColor = .white
        walletBalance.textAlignment = .center
        walletBalance.font = UIFont(name: "Avenir-Black", size: 50)
        
        let walletBalanceLabel = UILabel()
        walletBalanceLabel.frame = CGRect(x: 0, y: walletBalance.frame.origin.y + 50, width: UIScreen.main.bounds.width*0.5, height: 20)
        walletBalanceLabel.text = "Total Balance"
        walletBalanceLabel.textColor = .white
        walletBalanceLabel.textAlignment = .center
        walletBalanceLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        walletBalanceLabel.layer.opacity = 0.6
        
        
        let color1 = UIColor(red:0.84, green:0.55, blue:0.91, alpha:1.0).cgColor
        let color2 = UIColor(red:0.49, green:0.38, blue:0.99, alpha:1.0).cgColor
        walletOverviewStatusView.colors = [color1, color2]
        
        walletOverviewStatusView.locations = [0.0, 1.0]
        
        view.layer.addSublayer(walletOverviewStatusView)
        view.addSubview(walletTitleLabel)
        view.addSubview(walletSubtitleLabel)
        view.addSubview(walletBalanceLabel)
        view.addSubview(walletBalance)
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
