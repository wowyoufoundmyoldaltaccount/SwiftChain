//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Foundation
import MultipeerConnectivity

class MyViewController : UIViewController, UITextFieldDelegate {
    
    var coinChain = blockChain()
    
    let walletBalance = UILabel()

    let peerService = PeerManager()
    
    let popupView = UIView()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUserInterface(destView: view)
        
        coinChain.addGenesisBlock()
        
        refreshUI(destView: view)
        
        //coinChain.pushNetwork(pushedBlockchain: coinChain)
        dump(coinChain)
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
    
    @objc func presentTransactionView() {
        let destinationView = view
        
        popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY + 40, width: UIScreen.main.bounds.width*0.5 - 9, height: UIScreen.main.bounds.height * 0.653)
        popupView.backgroundColor = .white
        
        popupView.layer.zPosition = 7
        
        popupView.layer.cornerRadius = 30
        
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowRadius = 80.0
        
        let transactionsTitleLabel = UILabel()
        transactionsTitleLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width*0.5, height: 20)
        transactionsTitleLabel.text = "Create Transaction"
        transactionsTitleLabel.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        transactionsTitleLabel.textAlignment = .center
        transactionsTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        transactionsTitleLabel.layer.opacity = 1
        
        transactionsTitleLabel.layer.zPosition = 8
        
        let addressTextField = UITextField()
        addressTextField.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width*0.5 * 0.85, height: 40)
        addressTextField.center.x = self.view.center.x
        addressTextField.placeholder = "Wallet Address"
        addressTextField.font = UIFont(name: "Avenir-Heavy", size: 15)
        addressTextField.borderStyle = .none
        addressTextField.autocorrectionType = .no
        addressTextField.keyboardType = .default
        addressTextField.returnKeyType = .done
        addressTextField.clearButtonMode = .whileEditing
        addressTextField.contentVerticalAlignment = .center
        addressTextField.delegate = self
        addressTextField.backgroundColor = .white
        addressTextField.tintColor = .gray
        
        addressTextField.layer.cornerRadius = 6.8
        
        addressTextField.setLeftPaddingPoints(10)
        addressTextField.setRightPaddingPoints(10)
        
        
        addressTextField.layer.shadowColor = UIColor.black.cgColor
        addressTextField.layer.shadowOpacity = 0.08
        addressTextField.layer.shadowRadius = 15.0
        
        let avaliableWalletAddressesTitle = UILabel()
        avaliableWalletAddressesTitle.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width*0.5, height: 30)
        avaliableWalletAddressesTitle.text = "Wallets On Network"
        avaliableWalletAddressesTitle.textAlignment = .center
        avaliableWalletAddressesTitle.font = UIFont(name: "Avenir-Heavy", size: 20)
        avaliableWalletAddressesTitle.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: popupView.frame.width - 50, y: transactionsTitleLabel.frame.midY - 10, width: 40, height: 20)
        closeButton.setTitle("×", for: .normal)
        closeButton.setTitleColor(#colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1), for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 25)
        
        closeButton.layer.opacity = 1
        closeButton.layer.zPosition = 8
        
        closeButton.addTarget(self, action: #selector(closePopupView), for: .touchUpInside)
        
        destinationView?.addSubview(popupView)
        popupView.addSubview(transactionsTitleLabel)
        popupView.addSubview(closeButton)
        popupView.addSubview(addressTextField)
        popupView.addSubview(avaliableWalletAddressesTitle)
        
        addNetworkLabels(popupViewDest: popupView)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.popupView.frame.origin.y = 30
        }, completion: nil)
    }
    
    @objc func closePopupView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.popupView.frame.origin.y = 700
        }, completion: nil)
    }
    
    func addNetworkLabels(popupViewDest: UIView) {
        let networkObject = UserDefaults.standard.stringArray(forKey: "nodes")
        var enumerator = 0
        
        while enumerator != networkObject?.count {
            let walletLabel = UILabel()
            walletLabel.frame = CGRect(x: 0, y: Int(100 + 50 + enumerator * 30), width: Int(UIScreen.main.bounds.width*0.5), height: 30)
            walletLabel.text = "\(networkObject![enumerator])"
            walletLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
            walletLabel.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
            walletLabel.textAlignment = .center
            
            popupViewDest.addSubview(walletLabel)
            
            enumerator += 1
        }
    }
    
    func refreshUI(destView: UIView) {
        
        let walletAddressLabel = UILabel()
        walletAddressLabel.frame = CGRect(x: 0, y: 620, width: UIScreen.main.bounds.width*0.5, height: 25)
        walletAddressLabel.text = "Wallet Address: \(coinChain.walletAddress)"
        walletAddressLabel.textColor = .white
        walletAddressLabel.textAlignment = .center
        walletAddressLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        let walletAddressBackground = CAGradientLayer()
        walletAddressBackground.frame = CGRect(x: walletAddressLabel.frame.midX - UIScreen.main.bounds.width*0.5*0.9 / 2, y: walletAddressLabel.frame.midY - UIScreen.main.bounds.width*0.5*0.4/3.84/2, width: UIScreen.main.bounds.width*0.5*0.9, height: UIScreen.main.bounds.width*0.5*0.4/3.84)
        
        let color3 = UIColor(red:0.96, green:0.31, blue:0.64, alpha:1.0).cgColor
        let color4 = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0).cgColor
        walletAddressBackground.colors = [color4, color3]
        walletAddressBackground.locations = [0.0, 1.5]
        
        walletAddressBackground.zPosition = 6
        walletAddressBackground.cornerRadius = 6.5
        
        walletAddressBackground.shadowColor = UIColor.black.cgColor
        walletAddressBackground.shadowOpacity = 0.2
        walletAddressBackground.shadowRadius = 15.0
        
        let transactionCountText = UILabel()
        transactionCountText.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width*0.5, height: 40)
        transactionCountText.text = "0 transactions found."
        transactionCountText.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
        transactionCountText.textAlignment = .center
        transactionCountText.font = UIFont(name: "Avenir-Black", size: 30)
        transactionCountText.layer.zPosition = 6
        
        let addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 260, width: UIScreen.main.bounds.width*0.5, height: 20)
        addButton.setTitle("Make One!", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.contentHorizontalAlignment = .center
        addButton.contentVerticalAlignment = .center
        addButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        addButton.layer.zPosition = 7
        
        addButton.addTarget(self, action: #selector(presentTransactionView), for: .touchUpInside)
        
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
        
        walletAddressLabel.layer.zPosition = 7
        walletAddressBackground.zPosition = 6
        
        print("refreshing UI")
        
        print(coinChain.walletAddress)
        
        if coinChain.chain.count < 2 {
            print("only genesis block exists in chain")
        }
        
        walletBalance.text = "\(coinChain.totalAmountBalance) SXC"
        destView.addSubview(walletAddressLabel)
        destView.layer.addSublayer(walletAddressBackground)
        destView.addSubview(transactionCountText)
        destView.addSubview(addButton)
        destView.layer.addSublayer(addButtonButton)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
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
    var nodes = [String()]

    init() {
        print("initialized")
        walletAddress = randomString(length: 13)
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
    
    func pushNetwork(pushedBlockchain: blockChain) {
        if isKeyPresentInUserDefaults(key: "networkBlockchain") {
            var networkObject = UserDefaults.standard.object(forKey: "networkBlockchain") as! blockChain
        } else {
            UserDefaults.standard.setValue(pushedBlockchain, forKey: "networkBlockchain")
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey:key) != nil
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

class PeerManager: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    let serviceType = "example-color"
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
}

extension PeerManager {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = MyViewController()
