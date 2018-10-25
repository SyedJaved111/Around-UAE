//
//  OrderDetail.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCOrderDetail: BaseController {

    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var ConfirmedOrderList = [SomeOrderDetails]()
    var orderData:OrderData?
    
    @IBOutlet var confirmedTableView: UITableView!{
        didSet{
            self.confirmedTableView.delegate = self
            self.confirmedTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        ConfirmedOrderList = orderData?.orderDetails ?? []
        confirmedTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addBackButton()
        self.title = "Order Detail"
    }
    
    private func setupData(){
         lblOrderNumber.text = orderData?.payerId
         lblAmount.text = "$\(orderData?.charges ?? 0.0)"
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: orderData?.createdAt! ?? "")!
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        
         lblDate.text = dateString
         lblTotal.text = "\(orderData?.orderDetails?.count ?? 0)"
         lblStatus.text = orderData?.status
    }
}

extension VCOrderDetail:UITableViewDelegate,UITableViewDataSource,OrderDetailPrortocol{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfirmedOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell")  as! OrderDetailCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setupData(order: ConfirmedOrderList[indexPath.row])
        return cell
    }
    
    func tapOnReceived(cell:OrderDetailCell){
        let indexpath = confirmedTableView.indexPath(for: cell)
        makeProductComplete(orderid: ConfirmedOrderList[(indexpath?.row ?? 0)]._id ?? "")
    }
    
    private func makeProductComplete(orderid:String){
        startLoading("")
        OrderManager().MakeProductComplete(orderid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let completedResponse = response{
                    if completedResponse.success!{
                        self?.alertMessage(message:(completedResponse.message?.en ?? "").localized, completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message:(completedResponse.message?.en ?? "").localized, completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
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
}
