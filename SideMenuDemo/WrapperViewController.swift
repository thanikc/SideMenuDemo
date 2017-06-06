//
//  WrapperViewController.swift
//  SideMenuDemo
//
//  Created by Thanik Cheowtirakul on 17/5/16.
//  Copyright © 2016 Thanik Cheowtirakul. All rights reserved.
//

import UIKit

class WrapperViewController: UIViewController {
  
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth:CGFloat = 260
    
    // Need a handle to the scrollView to open and close the menu
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        DispatchQueue.main.async {
            self.closeMenu(false)
        }
        
        // Tab bar controller's child pages have a top-left button toggles the menu
        NotificationCenter.default.addObserver(self, selector: #selector(WrapperViewController.toggleMenu), name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WrapperViewController.closeMenuViaNotification), name: NSNotification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        
        // Close the menu when the device rotates
        NotificationCenter.default.addObserver(self, selector: #selector(WrapperViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // LeftMenu sends openModalWindow
        NotificationCenter.default.addObserver(self, selector: #selector(WrapperViewController.openModalWindow), name: NSNotification.Name(rawValue: "openModalWindow"), object: nil)
        
    }
    
    // Cleanup notifications added in viewDidLoad
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func openModalWindow(){
        performSegue(withIdentifier: "openModalWindow", sender: nil)
    }
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    // This wrapper function is necessary because
    // closeMenu params do not match up with Notification
    func closeMenuViaNotification(){
        closeMenu()
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closeMenu(_ animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup.
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // see http://stackoverflow.com/questions/25666269/ios8-swift-how-to-detect-orientation-change
    // close the menu when rotating to landscape.
    // Note: you have to put this on the main queue in order for it to work
    func rotated(){
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            DispatchQueue.main.async {
                print("closing menu on rotate")
                self.closeMenu()
            }
        }
    }
    
}

extension WrapperViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")
    }
    
    // http://www.4byte.cn/question/49110/uiscrollview-change-contentoffset-when-change-frame.html
    // When paging is enabled on a Scroll View,
    // a private method _adjustContentOffsetIfNecessary gets called,
    // presumably when present whatever controller is called.
    // The idea is to disable paging.
    // But we rely on paging to snap the slideout menu in place
    // (if you're relying on the built-in pan gesture).
    // So the approach is to keep paging disabled.
    // But enable it at the last minute during scrollViewWillBeginDragging.
    // And then turn it off once the scroll view stops moving.
    //
    // Approaches that don't work:
    // 1. automaticallyAdjustsScrollViewInsets -- don't bother
    // 2. overriding _adjustContentOffsetIfNecessary -- messing with private methods is a bad idea
    // 3. disable paging altogether.  works, but at the loss of a feature
    // 4. nest the scrollview inside UIView, so UIKit doesn't mess with it.  may have worked before,
    //    but not anymore.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = false
    }
}

