//
//  ViewController+Menu.swift
//  SideMenu
//
//  Created by Wendell Antildes M Sampaio on 02/04/2016.
//  Copyright © 2016 Wendell Antildes M Sampaio. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController : UIViewControllerTransitioningDelegate{
    
    func addLeftMenu(){
        let menuItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openLeftMenu(_:)))
        self.navigationItem.leftBarButtonItem = menuItem
        
    }
    
    func openLeftMenu(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! UITableViewController
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        self.present(pvc, animated: true, completion: nil)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is MenuViewController {
            return MenuPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is MenuViewController {
            return MenuPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }


    
    
}
