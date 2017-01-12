//
//  MenuViewController.swift
//  SideMenu
//
//  Created by Wendell Antildes M Sampaio on 29/03/2016.
//  Copyright © 2016 Wendell Antildes M Sampaio. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSwipeGesture()
        self.addTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window, let rootNavigationController = window.rootViewController as? UINavigationController, let storyboard = rootNavigationController.storyboard else{
                return
        }
        
        if indexPath.row < self.tableView.numberOfRows(inSection: 0){
            switch indexPath.row {
            case 0:
                let firstViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
                rootNavigationController.setViewControllers([firstViewController], animated: false)
            case 1:
                let firstViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
                rootNavigationController.setViewControllers([firstViewController], animated: false)
            case 2:
                let firstViewController = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
                rootNavigationController.setViewControllers([firstViewController], animated: false)
            default:
                break
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addSwipeGesture(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(MenuViewController.swipeLeft(_:)))
        gesture.direction = .left
        self.view.addGestureRecognizer(gesture)
    }
    
    func addTapGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.tapGesture(_:)))
        gesture.cancelsTouchesInView = false
        let window = UIApplication.shared.delegate!.window!
        window!.addGestureRecognizer(gesture)
    }
    
    func swipeLeft(_ recognizer : UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapGesture(_ recognizer : UITapGestureRecognizer){
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window else{
            return
        }
        let point = recognizer.location(in: nil)
        let pointInSubview = self.view.convert(point, from: window)
        if !self.view.frame.contains(pointInSubview){
            self.dismiss(animated: true, completion: nil)
        }
    }

}

class MenuPresentationController : UIPresentationController {
    
    lazy var dimmingView :UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        view.alpha = 0.0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        self.dimmingView.frame = self.containerView!.bounds
        self.dimmingView.alpha = 0.0
        
        self.containerView!.addSubview(self.dimmingView)
        self.containerView!.addSubview(self.presentedView!)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator!.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.alpha  = 1.0
            }, completion:nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool)  {
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator!.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.alpha  = 0.0
            }, completion:nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return CGRect(x: 0, y: 0, width: containerView!.bounds.width/1.5, height: containerView!.bounds.height)
    }
}

class MenuPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting :Bool
    let duration : TimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView

        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.center.x -= containerView.bounds.size.width
        containerView.addSubview(presentedControllerView)
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.x += containerView.bounds.size.width
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            else {
                return
        }
        let containerView = transitionContext.containerView
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.x -= containerView.bounds.size.width
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
}
