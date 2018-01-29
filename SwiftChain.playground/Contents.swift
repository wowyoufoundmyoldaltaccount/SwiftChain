//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Foundation
import MultipeerConnectivity

class MyViewController : UIViewController {
    
    var coinChain = blockChain()
    
    let walletBalance = UILabel()

    let peerService = PeerManager()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        initUserInterface(destView: view)
        
        coinChain.addGenesisBlock()
        
        refreshUI(destView: view)
        
        self.view = view
    }
    
    func initUserInterface(destView: UIView) {
        
        //Initial UI Setup
        
        let walletOverviewView = UIView()
        walletOverviewView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.5, height: UIScreen.main.bounds.height * 0.653 * 0.275)
        walletOverviewView.backgroundColor = #colorLiteral(red: 0.3015184316, green: 1, blue: 0.3607719276, alpha: 0)
        
        let walletTransactionsView = UIView()
        walletTransactionsView.frame = CGRect(x: 0, y: walletOverviewView.frame.height - 15, width: UIScreen.main.bounds.width*0.5 - 9, height: UIScreen.main.bounds.height * 0.653 - walletOverviewView.frame.height + 60)
        walletTransactionsView.backgroundColor = .white
        
        walletTransactionsView.layer.zPosition = 4
        
        walletTransactionsView.layer.cornerRadius = 30
        
        walletTransactionsView.layer.shadowColor = UIColor.black.cgColor
        walletTransactionsView.layer.shadowOpacity = 0.2
        walletTransactionsView.layer.shadowRadius = 35.0
        
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
        walletBalanceLabel.layer.opacity = 0.5
        
        walletBalanceLabel.layer.shadowColor = UIColor.black.cgColor
        walletBalanceLabel.layer.shadowOpacity = 0.3
        walletBalanceLabel.layer.shadowRadius = 15.0
        
        let transactionsTitleLabel = UILabel()
        transactionsTitleLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width*0.5, height: 20)
        transactionsTitleLabel.text = "Transactions"
        transactionsTitleLabel.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        transactionsTitleLabel.textAlignment = .center
        transactionsTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        transactionsTitleLabel.layer.opacity = 1
        
        transactionsTitleLabel.layer.zPosition = 5
        
        
        let color1 = UIColor(red:0.96, green:0.31, blue:0.64, alpha:1.0).cgColor
        let color2 = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0).cgColor
        walletOverviewStatusLayerView.colors = [color2, color1]
        
        walletOverviewStatusLayerView.locations = [0.0, 1.0]
        
        destView.layer.addSublayer(walletOverviewStatusLayerView)
        destView.addSubview(walletOverviewView)
        destView.addSubview(walletTransactionsView)
        walletTransactionsView.addSubview(transactionsTitleLabel)
        walletOverviewView.addSubview(walletTitleLabel)
        walletOverviewView.addSubview(walletBalanceLabel)
        walletOverviewView.addSubview(walletBalance)
    }
    
    func refreshUI(destView: UIView) {
        
        let transactionCountText = UILabel()
        transactionCountText.frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.width*0.5, height: 40)
        transactionCountText.text = "0 transactions found."
        transactionCountText.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        transactionCountText.textAlignment = .center
        transactionCountText.font = UIFont(name: "Avenir-Black", size: 30)
        transactionCountText.layer.zPosition = 6
        
        let addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 610, width: UIScreen.main.bounds.width*0.5, height: 15)
        addButton.setTitle("Make One!", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.contentHorizontalAlignment = .center
        addButton.contentVerticalAlignment = .center
        addButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        addButton.layer.zPosition = 7
        
        let addButtonButton = CAGradientLayer()
        addButtonButton.frame = CGRect(x: addButton.frame.midX - UIScreen.main.bounds.width*0.5*0.4 / 2, y: addButton.frame.midY - UIScreen.main.bounds.width*0.5*0.4/3.84/2, width: UIScreen.main.bounds.width*0.5*0.4, height: UIScreen.main.bounds.width*0.5*0.4/3.84)
        
        let color1 = UIColor(red:0.96, green:0.31, blue:0.64, alpha:1.0).cgColor
        let color2 = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0).cgColor
        addButtonButton.colors = [color2, color1]
        addButtonButton.locations = [0.0, 1.5]
        
        addButtonButton.zPosition = 6
        addButtonButton.cornerRadius = 6.5
        
        addButtonButton.shadowColor = UIColor.black.cgColor
        addButtonButton.shadowOpacity = 0.18
        addButtonButton.shadowRadius = 15.0
        
        print("refreshing UI")
        
        print(coinChain.walletAddress)
        
        if coinChain.chain.count < 2 {
            print("only genesis block exists in chain")
        }
        
        walletBalance.text = "\(coinChain.totalAmountBalance) SXC"
        destView.addSubview(transactionCountText)
        destView.addSubview(addButton)
        destView.layer.addSublayer(addButtonButton)
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

class PeerManager: NSObject {
    let serviceType = "example-color"
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        super.init()
        self.serviceAdvertiser.delegate = self as? MCNearbyServiceAdvertiserDelegate
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension PeerManager {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = MyViewController()
