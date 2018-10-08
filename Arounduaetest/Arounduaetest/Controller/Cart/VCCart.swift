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
    var cartProductList = [Product]()
    
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
                            self?.alertMessage(message: cartProductData.message?.en ?? "", completionHandler: nil)
                        }else{
                            self?.cartProductList = cartProductData.data ?? []
                            self?.myTbleView.reloadData()
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
    
    private func deleteCartProduct(_ product:Product){
        startLoading("")
        CartManager().deleteCartProducts((product._id!,product._id!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let cartProductData = response{
                    if cartProductData.success!{
                        if(cartProductData.data ?? []).count == 0{
                            self?.alertMessage(message: cartProductData.message?.en ?? "", completionHandler: nil)
                        }else{
                            self?.cartProductList = cartProductData.data ?? []
                            self?.myTbleView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Cart"
        self.addBackButton()
    }
    
    override func viewDidLayoutSubviews(){
        super.updateViewConstraints()
        tableheightconstraint.constant = myTbleView.contentSize.height
        cartscrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: myTbleView.contentSize.height + 180)
    }

    @IBAction func ContinueClick(_ sender: Any) {
        var items = [PayPalItem]()
        for obj in cartProductList{
            let item = PayPalItem(name: obj.productName?.en ?? "", withQuantity: 1, withPrice: NSDecimalNumber(string: "\(obj.price?.usd ?? 0)"), withCurrency: "USD", withSku: "Hip-0037")
            items.append(item)
        }
        let subtotal = PayPalItem.totalPrice(forItems: items)
        let payment = PayPalPayment(amount: subtotal, currencyCode: "USD", shortDescription: "", intent: .sale)
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
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension VCCart: Cartprotocol{
    func tapOnDeleteProduct(cell:CartCell){
        let indxpath = myTbleView.indexPath(for: cell)
        deleteCartProduct(cartProductList[(indxpath?.row)!])
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
            
            //self.sendPaymentToServer(bookingId : "\(self.User.bookingId!)", paypaId : payauid)
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
    
    private func sendPyamentToServer(_ paymentId:String, token:String){
        startLoading("")
        CartManager().Payment((paymentId,token),
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
