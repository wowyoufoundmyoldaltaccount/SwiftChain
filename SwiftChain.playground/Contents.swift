//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Foundation
import Security

class MyViewController : UIViewController {
    
    var coinChain = blockChain()
    
    let walletBalance = UILabel()

    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        initUserInterface(destView: view)
        
        coinChain.addGenesisBlock()
        
        coinChain.addBlock(newBlock: block(index: 1, dateCreated: "01/28/18", amountTransfered: 10, previousHash: coinChain.getLatestBlock().hash, destAddress: "\(coinChain.walletAddress)"))
        
        
        refreshUI()
        
        self.view = view
    }
    
    func initUserInterface(destView: UIView) {
        
        //Initial UI Setup
        
        let walletOverviewView = UIView()
        walletOverviewView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height * 0.653 * 0.275)
        walletOverviewView.backgroundColor = #colorLiteral(red: 0.3015184316, green: 1, blue: 0.3607719276, alpha: 0)
        
        let walletTransactionsView = UIView()
        walletTransactionsView.frame = CGRect(x: 0, y: walletOverviewView.frame.height - 15, width: UIScreen.main.bounds.width*0.5 - 9, height: UIScreen.main.bounds.height * 0.653 - walletOverviewView.frame.height)
        walletTransactionsView.backgroundColor = .white
        
        walletTransactionsView.layer.zPosition = 4
        
        walletTransactionsView.layer.cornerRadius = 30
        
        walletTransactionsView.layer.shadowColor = UIColor.black.cgColor
        walletTransactionsView.layer.shadowOpacity = 0.05
        walletTransactionsView.layer.shadowRadius = 15.0
        
        let walletOverviewStatusLayerView = CAGradientLayer()
        walletOverviewStatusLayerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height * 0.653 * 0.3)
        
        let walletTitleLabel = UILabel()
        walletTitleLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width*0.5, height: 50)
        walletTitleLabel.text = "SwiftChain"
        walletTitleLabel.textColor = .white
        walletTitleLabel.textAlignment = .center
        walletTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        walletBalance.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.5, height: walletOverviewView.frame.height)
        walletBalance.text = "0.0 SXC"
        walletBalance.textColor = .white
        walletBalance.textAlignment = .center
        walletBalance.font = UIFont(name: "Avenir-Black", size: 50)
        
        let walletBalanceLabel = UILabel()
        walletBalanceLabel.frame = CGRect(x: 0, y: walletBalance.frame.origin.y + 40, width: UIScreen.main.bounds.width*0.5, height: walletOverviewView.frame.height)
        walletBalanceLabel.text = "Total Balance"
        walletBalanceLabel.textColor = .white
        walletBalanceLabel.textAlignment = .center
        walletBalanceLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        walletBalanceLabel.layer.opacity = 0.6
        
        let transactionsTitleLabel = UILabel()
        transactionsTitleLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width*0.5, height: 20)
        transactionsTitleLabel.text = "Transactions"
        transactionsTitleLabel.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        transactionsTitleLabel.textAlignment = .center
        transactionsTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        transactionsTitleLabel.layer.opacity = 1
        
        transactionsTitleLabel.layer.zPosition = 5
        
        
        let color1 = UIColor(red:0.84, green:0.55, blue:0.91, alpha:1.0).cgColor
        let color2 = UIColor(red:0.49, green:0.38, blue:0.99, alpha:1.0).cgColor
        walletOverviewStatusLayerView.colors = [color1, color2]
        
        walletOverviewStatusLayerView.locations = [0.0, 1.0]
        
        destView.layer.addSublayer(walletOverviewStatusLayerView)
        destView.addSubview(walletOverviewView)
        destView.addSubview(walletTransactionsView)
        walletTransactionsView.addSubview(transactionsTitleLabel)
        walletOverviewView.addSubview(walletTitleLabel)
        walletOverviewView.addSubview(walletBalanceLabel)
        walletOverviewView.addSubview(walletBalance)
    }
    
    func refreshUI() {
        print("refreshing UI")
        
        print(coinChain.walletAddress)
        
        walletBalance.text = "\(coinChain.totalAmountBalance) SXC"
    }
}

class block {
    var addedString = String()
    var hash = String()
    var previousHash = String()
    var index = Int()
    var dateCreated = String()
    var amountTransfered = Int()
    var destAddress = String()
    
    init(index: Int, dateCreated: String, amountTransfered: Int, previousHash: String, destAddress: String) {
        addedString = "\(index)\(dateCreated)\(amountTransfered)\(previousHash)\(destAddress)"
        self.hash = calculateHash()
        self.previousHash = previousHash
        self.index = index
        self.dateCreated = dateCreated
        self.amountTransfered = amountTransfered
        self.destAddress = destAddress
    }
    
    func calculateHash() -> String {
        var hashString = "\(addedString.hashValue)"
        hashString = hashString.replacingOccurrences(of: "-", with: "")
        return hashString
    }

}

class blockChain {
    //create genesis block
    
    var totalAmountBalance = 0.0
    var walletAddress = String()
    var chain = [block(index: 0, dateCreated: "01/27/2018", amountTransfered: 0, previousHash: "0", destAddress: "")]

    init() {
        print("initialized")
        walletAddress = randomString(length: 20)
        chain = [block(index: 0, dateCreated: "01/27/2018", amountTransfered: 0, previousHash: "0", destAddress: walletAddress)]
        totalAmountBalance = 0.0
    }
    
    
    
    func getLatestBlock() -> block {
        return chain[Int(chain.count - 1)]
    }
    
    func addGenesisBlock() {
        print("Genesis block created")
        
        print("Wallet address: \(walletAddress)")
    }

    func addBlock(newBlock: block) {
        
        if newBlock.destAddress != "\(walletAddress)" {
            print("sent to another wallet")
            print("subtract from total value")
            
            print("New block address: \(newBlock.destAddress)")
            
            totalAmountBalance = Double(totalAmountBalance) - Double(newBlock.amountTransfered)
        } else {
            totalAmountBalance = Double(totalAmountBalance) + Double(newBlock.amountTransfered)
        }
        
        if newBlock.previousHash == getLatestBlock().hash {
            chain.append(newBlock)
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
