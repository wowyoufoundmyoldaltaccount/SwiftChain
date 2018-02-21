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
    
    var sessionWallet = wallet()
    
    var newTransaction = block()
    
    var newTransactionAmount = Int()
    
    var newTransactionDestAddress = String()
    
    let addressTextField = UITextField()
    
    let transactionAmountLabel = UILabel()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        let result = formatter.string(from: date)
        
        initUserInterface(destView: view)
        
        coinChain.addGenesisBlock()
        
        coinChain.newWallet(walletToAdd: sessionWallet)
        
        coinChain.addBlock(newBlock: block(index: coinChain.chain.count, dateCreated: "\(result)", amountTransfered: 100, previousHash: coinChain.chain[coinChain.chain.count - 1].hash, destAddress: sessionWallet.walletAddress, sendingAddress: ""))
        refreshUI(destView: view)
        
        initTransactionView()
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
    
    @objc func initTransactionView() {
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
        
        transactionAmountLabel.frame = CGRect(x: 0, y: popupView.frame.midY, width: UIScreen.main.bounds.width*0.5, height: 40)
        transactionAmountLabel.text = "\(newTransactionAmount) SXC"
        transactionAmountLabel.font = UIFont(name: "Avenir-Heavy", size: 35)
        transactionAmountLabel.textAlignment = .center
        transactionAmountLabel.layer.opacity = 1
        transactionAmountLabel.textColor = UIColor(red: 0.96, green: 0.31, blue: 0.64, alpha: 0.7)
        transactionAmountLabel.layer.zPosition = 9
        
        let tenButton = UIButton()
        tenButton.frame = CGRect(x: 10, y: UIScreen.main.bounds.height*0.653 - 110, width: UIScreen.main.bounds.width*0.5*0.8*0.25, height: 20)
        tenButton.setTitle("10 SXC", for: .normal)
        tenButton.setTitleColor(.white, for: .normal)
        tenButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        tenButton.titleLabel?.textAlignment = .center
        
        tenButton.layer.zPosition = 7
        
        let tenButtonBackground =  CAGradientLayer()
        tenButtonBackground.frame = CGRect(x: 5, y: UIScreen.main.bounds.height*0.653 - 110 - 5, width: UIScreen.main.bounds.width*0.5*0.8*0.25 + 10, height: 30)
        
        let color3 = UIColor(red:0.96, green:0.31, blue:0.64, alpha:1.0).cgColor
        let color4 = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0).cgColor
        tenButtonBackground.colors = [color4, color3]
        tenButtonBackground.locations = [0.0, 1.5]
        
        tenButtonBackground.zPosition = 6
        tenButtonBackground.cornerRadius = 6.5
        
        tenButtonBackground.shadowColor = UIColor.black.cgColor
        tenButtonBackground.shadowOpacity = 0.2
        tenButtonBackground.shadowRadius = 15.0
        
        
        let twentyButton = UIButton()
        twentyButton.frame = CGRect(x: tenButton.frame.maxX + 15, y: UIScreen.main.bounds.height*0.653 - 110, width: UIScreen.main.bounds.width*0.5*0.8*0.25, height: 20)
        twentyButton.setTitle("20 SXC", for: .normal)
        twentyButton.setTitleColor(.white, for: .normal)
        twentyButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        twentyButton.titleLabel?.textAlignment = .center
        
        twentyButton.layer.zPosition = 8
        
        let twentyButtonBackground =  CAGradientLayer()
        twentyButtonBackground.frame = CGRect(x: twentyButton.frame.minX  - 5, y: UIScreen.main.bounds.height*0.653 - 110 - 5, width: UIScreen.main.bounds.width*0.5*0.8*0.25 + 10, height: 30)
        
        twentyButtonBackground.colors = [color4, color3]
        twentyButtonBackground.locations = [0.0, 1.5]
        
        twentyButtonBackground.zPosition = 6
        twentyButtonBackground.cornerRadius = 6.5
        
        twentyButtonBackground.shadowColor = UIColor.black.cgColor
        twentyButtonBackground.shadowOpacity = 0.2
        twentyButtonBackground.shadowRadius = 15.0
        
        let thirtyButton = UIButton()
        thirtyButton.frame = CGRect(x: UIScreen.main.bounds.width*0.5 - UIScreen.main.bounds.width*0.5*0.8*0.25 - 20 - UIScreen.main.bounds.width*0.5*0.8*0.25 - 20 + 5, y: UIScreen.main.bounds.height*0.653 - 110, width: UIScreen.main.bounds.width*0.5*0.8*0.25, height: 20)
        thirtyButton.setTitle("30 SXC", for: .normal)
        thirtyButton.setTitleColor(.white, for: .normal)
        thirtyButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        thirtyButton.titleLabel?.textAlignment = .center
        
        thirtyButton.layer.zPosition = 8
        
        let thirtyButtonBackground =  CAGradientLayer()
        thirtyButtonBackground.frame = CGRect(x: thirtyButton.frame.minX  - 5, y: UIScreen.main.bounds.height*0.653 - 110 - 5, width: UIScreen.main.bounds.width*0.5*0.8*0.25 + 10, height: 30)
        
        thirtyButtonBackground.colors = [color4, color3]
        thirtyButtonBackground.locations = [0.0, 1.5]
        
        thirtyButtonBackground.zPosition = 6
        thirtyButtonBackground.cornerRadius = 6.5
        
        thirtyButtonBackground.shadowColor = UIColor.black.cgColor
        thirtyButtonBackground.shadowOpacity = 0.2
        thirtyButtonBackground.shadowRadius = 15.0
        
        let fiftyButton = UIButton()
        fiftyButton.frame = CGRect(x: UIScreen.main.bounds.width*0.5 - UIScreen.main.bounds.width*0.5*0.8*0.25 - 20, y: UIScreen.main.bounds.height*0.653 - 110, width: UIScreen.main.bounds.width*0.5*0.8*0.25, height: 20)
        fiftyButton.setTitle("50 SXC", for: .normal)
        fiftyButton.setTitleColor(.white, for: .normal)
        fiftyButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        fiftyButton.titleLabel?.textAlignment = .center
        
        fiftyButton.layer.zPosition = 8
        
        let fiftyButtonBackground =  CAGradientLayer()
        fiftyButtonBackground.frame = CGRect(x: fiftyButton.frame.minX  - 5, y: UIScreen.main.bounds.height*0.653 - 110 - 5, width: UIScreen.main.bounds.width*0.5*0.8*0.25 + 10, height: 30)
        
        fiftyButtonBackground.colors = [color4, color3]
        fiftyButtonBackground.locations = [0.0, 1.5]
        
        fiftyButtonBackground.zPosition = 6
        fiftyButtonBackground.cornerRadius = 6.5
        
        fiftyButtonBackground.shadowColor = UIColor.black.cgColor
        fiftyButtonBackground.shadowOpacity = 0.2
        fiftyButtonBackground.shadowRadius = 15.0
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height*0.653 - 80, width: UIScreen.main.bounds.width * 0.5, height: 35)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        doneButton.titleLabel?.textAlignment = .center
        
        doneButton.layer.zPosition = 8
        
        tenButton.addTarget(self, action: #selector(setTransactionAmountTen), for: .touchUpInside)
        twentyButton.addTarget(self, action: #selector(setTransactionAmountTwenty), for: .touchUpInside)
        thirtyButton.addTarget(self, action: #selector(setTransactionAmountThirty), for: .touchUpInside)
        fiftyButton.addTarget(self, action: #selector(setTransactionAmountFifty), for: .touchUpInside)
        
        doneButton.addTarget(self, action: #selector(createTransaction), for: .touchUpInside)
        
        let doneButtonBackground =  CAGradientLayer()
        doneButtonBackground.frame = CGRect(x: tenButtonBackground.frame.minX, y: UIScreen.main.bounds.height*0.653 - 80, width: UIScreen.main.bounds.width*0.5 - tenButtonBackground.frame.minX*4, height: 35)
        
        doneButtonBackground.colors = [color4, color3]
        doneButtonBackground.locations = [0.0, 1.5]
        
        doneButtonBackground.zPosition = 6
        doneButtonBackground.cornerRadius = 6.5
        
        doneButtonBackground.shadowColor = UIColor.black.cgColor
        doneButtonBackground.shadowOpacity = 0.2
        doneButtonBackground.shadowRadius = 15.0
        
        addressTextField.frame = CGRect(x: 57.6/2, y: 60, width: UIScreen.main.bounds.width*0.5 * 0.85, height: 40)
        addressTextField.center.x = popupView.center.x
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
        addressTextField.textColor = .gray
        
        addressTextField.layer.cornerRadius = 6.8
        
        addressTextField.tag = 3
        
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
        popupView.addSubview(tenButton)
        popupView.addSubview(twentyButton)
        popupView.addSubview(thirtyButton)
        popupView.addSubview(fiftyButton)
        popupView.addSubview(doneButton)
        popupView.addSubview(transactionAmountLabel)
        popupView.layer.addSublayer(tenButtonBackground)
        popupView.layer.addSublayer(twentyButtonBackground)
        popupView.layer.addSublayer(thirtyButtonBackground)
        popupView.layer.addSublayer(fiftyButtonBackground)
        popupView.layer.addSublayer(doneButtonBackground)
        
        addNetworkLabels(popupViewDest: popupView)
    }

    @objc func bringPopupViewToForeground() {
        newTransactionAmount = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.popupView.frame.origin.y = 30
        }, completion: nil)
    }

    @objc func createTransaction() {
        newTransaction = block(index: coinChain.chain.count, dateCreated: "2/12/2018", amountTransfered: newTransactionAmount, previousHash: coinChain.chain[coinChain.chain.count - 1].hash, destAddress: addressTextField.text!, sendingAddress: sessionWallet.walletAddress)
        
        if Double(newTransactionAmount) <= sessionWallet.balance {
            if addressTextField.text! != sessionWallet.walletAddress {
                coinChain.addBlock(newBlock: newTransaction)
                refreshUI(destView: view)
                closePopupView()
            } else {
                presentTransactionError()
            }
        } else {
            presentInsufficientFunds()
        }
    }
    
    @objc func setTransactionAmountTen() {
        newTransactionAmount += 10
        transactionAmountLabel.text = "\(newTransactionAmount)"
    }
    
    @objc func setTransactionAmountTwenty() {
        newTransactionAmount += 20
        transactionAmountLabel.text = "\(newTransactionAmount)"
    }
    
    @objc func setTransactionAmountThirty() {
        newTransactionAmount += 30
        transactionAmountLabel.text = "\(newTransactionAmount)"
    }
    
    @objc func setTransactionAmountFifty() {
        newTransactionAmount += 50
        transactionAmountLabel.text = "\(newTransactionAmount)"
    }
    
    @objc func closePopupView() {
        dump(coinChain.chain)
        UIView.animate(withDuration: 0.4, animations: {
            self.popupView.frame.origin.y = 700
        }, completion: nil)
    }
    
    func presentTransactionError() {
        let alert = UIAlertController(title: "Error", message: "Tokens cannot be sent to the sending wallet from the sending wallet.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentInsufficientFunds() {
        let alert = UIAlertController(title: "Error", message: "Insufficient funds.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        closePopupView()
    }
    
    func addNetworkLabels(popupViewDest: UIView) {
        let networkObject = coinChain.nodes
        var enumerator = 0
        
        while enumerator != networkObject.count {
            let walletLabel = UIButton()
            walletLabel.frame = CGRect(x: 0, y: Int(100 + 50 + enumerator * 30), width: Int(UIScreen.main.bounds.width*0.5), height: 30)
            walletLabel.setTitle("\(networkObject[enumerator].walletAddress)", for: .normal)
            walletLabel.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
            walletLabel.setTitleColor(#colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1), for: .normal)
            walletLabel.titleLabel?.textAlignment = .center
            
            walletLabel.addTarget(self, action: #selector(putTextIntoField), for: .touchUpInside)
            
            popupViewDest.addSubview(walletLabel)
            
            enumerator += 1
        }
        
        if enumerator == networkObject.count {
            let walletLabel = UILabel()
            walletLabel.frame = CGRect(x: 0, y: Int(100 + 50 + enumerator * 30), width: Int(UIScreen.main.bounds.width*0.5), height: 30)
            walletLabel.text = "Tap Address to Enter Into Field"
            walletLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
            walletLabel.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
            walletLabel.textAlignment = .center
            
            popupViewDest.addSubview(walletLabel)
        }
    }
    
    @objc func putTextIntoField(sender: UIButton) {
        let textField = view.viewWithTag(3) as! UITextField
        textField.text = sender.titleLabel?.text
    }
    
    func refreshUI(destView: UIView) {
        walletBalance.text = "\(sessionWallet.balance) SXC"
        
        let addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 260, width: UIScreen.main.bounds.width*0.5, height: 20)
        addButton.setTitle("Make One!", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.contentHorizontalAlignment = .center
        addButton.contentVerticalAlignment = .center
        addButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        addButton.layer.zPosition = 7
        
        addButton.addTarget(self, action: #selector(bringPopupViewToForeground), for: .touchUpInside)
        
        let addButtonButton = CAGradientLayer()
        addButtonButton.frame = CGRect(x: addButton.frame.midX - UIScreen.main.bounds.width*0.5*0.4 / 2, y: addButton.frame.midY - UIScreen.main.bounds.width*0.5*0.4/3.84/2, width: UIScreen.main.bounds.width*0.5*0.4, height: UIScreen.main.bounds.width*0.5*0.4/3.84)
        
        let color1 = UIColor(red:0.96, green:0.31, blue:0.64, alpha:1.0).cgColor
        let color2 = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0).cgColor
        addButtonButton.colors = [color2, color1]
        addButtonButton.locations = [0.0, 1.5]
        
        addButtonButton.zPosition = 6
        addButtonButton.cornerRadius = 6.5
        
        addButtonButton.shadowColor = UIColor.black.cgColor
        
        print("refreshing UI")
        
        if coinChain.chain.count < 3 {
            let transactionCountText = UILabel()
            transactionCountText.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width*0.5, height: 40)
            transactionCountText.text = "0 transactions found."
            transactionCountText.textColor = #colorLiteral(red: 0.8235294118, green: 0.8392156863, blue: 0.8509803922, alpha: 1)
            transactionCountText.textAlignment = .center
            transactionCountText.font = UIFont(name: "Avenir-Black", size: 30)
            transactionCountText.layer.zPosition = 6
            
            destView.addSubview(transactionCountText)
        }

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
    var sendingAddress = String()
    
    init(index: Int, dateCreated: String, amountTransfered: Int, previousHash: String, destAddress: String, sendingAddress: String) {
        addedString = "\(index)\(dateCreated)\(amountTransfered)\(previousHash)\(destAddress)"
        self.hash = calculateHash()
        self.previousHash = previousHash
        self.index = index
        self.dateCreated = dateCreated
        self.amountTransfered = amountTransfered
        self.destAddress = destAddress
        self.sendingAddress = sendingAddress
    }
    
    init() {
        
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
    var chain = [block(index: 0, dateCreated: "01/27/2018", amountTransfered: 0, previousHash: "0", destAddress: "", sendingAddress: "")]
    var nodes = [wallet()]

    init() {
        print("initialized")
        walletAddress = randomString(length: 13)
        chain = [block(index: 0, dateCreated: "01/27/2018", amountTransfered: 0, previousHash: "0", destAddress: walletAddress, sendingAddress: "")]
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
        if newBlock.previousHash == getLatestBlock().hash {
            chain.append(newBlock)
            findWallet(withAddress: newBlock.destAddress).balance += Double(newBlock.amountTransfered)
            
            findWallet(withAddress: newBlock.sendingAddress).balance -= Double(newBlock.amountTransfered)
        }
    }
    
    func findWallet(withAddress: String) -> wallet{
        var x = 0
        var destWalletRef = wallet()
        while x != nodes.count {
            if nodes[x].walletAddress == withAddress {
                destWalletRef = nodes[x]
                x = nodes.count + 1
                break
            }
            x+=1
        }
        return destWalletRef
    }
    
    func newWallet(walletToAdd: wallet) {
        nodes.append(walletToAdd)
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

class wallet {
    var balance = 0.0
    var walletAddress = ""
    init() {
        balance = 0.0
        walletAddress = randomString(length: 13)
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

let vc = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = vc
