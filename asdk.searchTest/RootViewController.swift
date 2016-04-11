//
//  RootViewController.swift
//  asdk.searchTest
//
//  Created by Tom King on 4/11/16.
//  Copyright © 2016 iZi Mobile. All rights reserved.
//

import UIKit

class RootViewController: UIViewController
{
    var button: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        button = UIButton()
        button.addTarget(self, action: #selector(RootViewController.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        button.setTitle("Push View Controller", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        view.addSubview(button)
        button.sizeToFit()
        button.center = view.center
    }
    
    func buttonPressed(sender: UIButton)
    {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}
