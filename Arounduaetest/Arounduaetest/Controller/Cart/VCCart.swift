//
//  VCCart.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class VCCart: UIViewController {
    
    @IBOutlet weak var btnCheckout: UIButtonMain!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalBill: UILabel!
    @IBOutlet weak var tableheightconstraint: NSLayoutConstraint!
    
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment){
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    var cartProductList = [ProductUAE]()
    
    @IBOutlet weak var cartscrollview: UIScrollView!
    @IBOutlet weak var myTbleView: UITableView!{
        didSet{
            myTbleView.delegate = self
            myTbleView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPayPal()
        getCartProducts()
    }
    
    func configPayPal(){
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Around UAE"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    private func getCartProducts(){
        startLoading("")
        CartManager().getCartProducts(
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let cartProductData = response{
                    if cartProductData.success!{
                        if(cartProductData.data ?? []).count == 0{
                            self?.btnCheckout.isEnabled = false
                            self?.btnCheckout.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        }else{
                            self?.cartProductList = cartProductData.data ?? []
                            self?.lblTotalPrice.text = "$\(self?.cartProductList.map({$0.total?.usd ?? 0}).reduce(0, +) ?? 0)"
                            self?.myTbleView.reloadData()
                            self?.btnCheckout.isEnabled = true
                            self?.btnCheckout.backgroundColor = #colorLiteral(red: 0.8874343038, green: 0.3020061255, blue: 0.4127213061, alpha: 1)
                            self?.setViewHeight()
                        }
                    }else{
                        self?.alertMessage(message: cartProductData.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func deleteCartProduct(_ product:ProductUAE,row:Int){
        startLoading("")
        CartManager().deleteCartProducts(((product.product?._id!)!,product.combination!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let cartProductData = response{
                    if cartProductData.success!{
                         self?.cartProductList.remove(at: row)
                         self?.lblTotalPrice.text = "$\(self?.cartProductList.map({$0.total?.usd ?? 0}).reduce(0, +) ?? 0)"
                         self?.myTbleView.reloadData()
                    }else{
                        self?.alertMessage(message: cartProductData.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func updateCartQuantity(_ product:ProductUAE,row:Int){
        CartManager().UpdateCartQuantity(("\(product.quantity!)",(product.product?._id!)!,product.combination!),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let cartProductData = response{
                        if cartProductData.success!{
                            var obj = self?.cartProductList[row].price
                            self?.lblTotalPrice.text = "$\(self?.cartProductList.map({$0.price?.usd ?? 0}).reduce(0, +) ?? 0)"
                            self?.myTbleView.reloadData()
                        }else{
                            self?.alertMessage(message: cartProductData.message?.en ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Cart"
        self.addBackButton()
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    

    private func setViewHeight(){
        tableheightconstraint.constant = myTbleView.contentSize.height + 50
        self.myTbleView.setNeedsDisplay()
    }

    @IBAction func ContinueClick(_ sender: Any) {
        var items = [PayPalItem]()
        for obj in cartProductList{
            let item = PayPalItem(name: obj.product?.productName?.en ?? "", withQuantity: UInt(obj.quantity ?? 0), withPrice: NSDecimalNumber(string: "\(obj.price?.usd ?? 0)"), withCurrency: "USD", withSku: "Hip-0037")
            items.append(item)
        }
        let subtotal = PayPalItem.totalPrice(forItems: items)
        let payment = PayPalPayment(amount: subtotal, currencyCode: "USD", shortDescription: "Some Description About product", intent: .sale)
        payment.items = items
        
        if(payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Payment not processalbe: \(payment)", okAction:nil)
            self.present(alertView, animated: true, completion: nil)
            print("Payment not processalbe: \(payment)")
        }
    }
}

extension VCCart: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cell.delegate = self
        cell.setupCartCell(cartProductList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension VCCart: Cartprotocol{
    func tapQuantity(cell: CartCell) {
        let indxpath = myTbleView.indexPath(for: cell)
        updateCartQuantity(cartProductList[(indxpath?.row)!], row: indxpath?.row ?? 0)
    }
    
    func tapOnDeleteProduct(cell:CartCell){
        let indxpath = myTbleView.indexPath(for: cell)
        deleteCartProduct(cartProductList[(indxpath?.row)!], row: indxpath?.row ?? 0)
    }
}

extension VCCart: PayPalPaymentDelegate, PayPalProfileSharingDelegate{
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController){
        paymentViewController.dismiss(animated: true, completion: nil)
        let alertView = AlertView.prepare(title: "Alert".localized, message: "PayPal Payment Cancelled", okAction:nil)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment){
        
            paymentViewController.dismiss(animated: true, completion: { () -> Void in
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            let paymentResultDic = completedPayment.confirmation as NSDictionary
            let dicResponse: AnyObject? = paymentResultDic.object(forKey: "response") as AnyObject?
            let payauid:String = dicResponse!["id"] as! String
            let paystate:String = dicResponse!["state"] as! String
            
            print("id is  --->%@",payauid)
            print("paystate is ----->%@",paystate)
            
            self.sendPyamentToServer(payauid)
        })
    }
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController){
        let alertView = AlertView.prepare(title: "Alert".localized, message: "PayPal Profile Sharing Authorization Canceled", okAction:nil)
        self.present(alertView, animated: true, completion: nil)
        print("PayPal Profile Sharing Authorization Canceled")
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]){
        print("PayPal Profile Sharing Authorization Canceled")
    }
    
    private func sendPyamentToServer(_ paymentId:String){
        startLoading("")
        CartManager().Payment(paymentId,
        successCallback:
        {[weak self](response) in
            
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}

