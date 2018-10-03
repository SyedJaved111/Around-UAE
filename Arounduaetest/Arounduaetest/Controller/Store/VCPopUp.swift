//
//  VCPopUp.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class VCPopUp: UIViewController {

    @IBOutlet var lblHowsExperience: UILabel!
    @IBOutlet var lblSubmitFeedBack: UILabel!
    @IBOutlet var textViewWriteComments: UICustomTextView!
    @IBOutlet var btnCancel: UIButtonMain!
    @IBOutlet var btnSubmit: UIButtonMain!
    @IBAction func btnAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblSubmitFeedBack.text = "Submit Feedback".localized
      lblSubmitFeedBack.text = "Hows was your experience with instinct Store?".localized
        
        textViewWriteComments.text = "Write Comments...".localized
        
        btnSubmit.setTitle("Submit".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
