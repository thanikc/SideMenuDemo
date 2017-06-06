//
//  ViewController2.swift
//  SideMenuDemo
//
//  Created by Thanik Cheowtirakul on 27/5/16.
//  Copyright © 2016 Thanik Cheowtirakul. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBAction func toggleMenu(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
