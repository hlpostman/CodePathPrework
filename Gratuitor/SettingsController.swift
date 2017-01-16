//
//  SettingsController.swift
//  Gratuitor
//
//  Created by Aristotle on 2017-01-15.
//  Copyright © 2017 HLPostman. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        
        // Return to main view controller
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(returnToMainViewController))
    }
    
    func returnToMainViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
