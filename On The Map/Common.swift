//
//  Common.swift
//  On The Map
//
//  Created by Udumala, Mary on 4/5/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class Common {
    
    //Two Actions Alert
    class func showUserAlert(messageTitle: String, message: String, actionTitle: String?, cancelActionTitle: String?, hostViewController: UIViewController, completionHandlerForAlert: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "\(messageTitle)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        if let actionTitle = actionTitle {
            let action = UIAlertAction(title: "\(actionTitle)", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                completionHandlerForAlert()
            }
            alertController.addAction(action)
        }
        
        if let cancelActionTitle = cancelActionTitle {
            let cancelAction = UIAlertAction(title: "\(cancelActionTitle)", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        hostViewController.present(alertController, animated: true, completion: nil)
    }
    
}
