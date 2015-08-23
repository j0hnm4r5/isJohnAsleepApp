//
//  ViewController.swift
//  isJohnAsleepApp
//
//  Created by John Mars on 8/22/15.
//  Copyright (c) 2015 M4R5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let asleepText = "I'm going to sleep"
	let awakeText  = "I woke up"
	
	var asleep = false
	
	//	let baseUrlString = "http://www.isjohnasleep.com/"
	let baseUrlString = "http://192.168.1.100:3000/"

	
	@IBOutlet weak var button: UIButton!
	@IBAction func buttonPress(sender: AnyObject) {
		
		var request = HTTPTask()
		
		if asleep {
			request.POST(baseUrlString + "awake", parameters: nil, completionHandler: {(response: HTTPResponse) in
				
				if let err = response.error {
					println("error: \(err.localizedDescription)")
					return
				}
				
				if let data = response.responseObject as? NSData {
					let str = NSString(data: data, encoding: NSUTF8StringEncoding)
					println(str!)
					
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.asleepText, forState: .Normal)
						UIView.animateWithDuration(1, animations: {
							self.view.backgroundColor = UIColor.redColor()
						})
					})

					self.asleep = !self.asleep
				}
			})
		} else {
			request.POST(baseUrlString + "asleep", parameters: nil, completionHandler: {(response: HTTPResponse) in
				
				if let err = response.error {
					println("error: \(err.localizedDescription)")
					return
				}
				
				if let data = response.responseObject as? NSData {
					let str = NSString(data: data, encoding: NSUTF8StringEncoding)
					println(str!)
					
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.awakeText, forState: .Normal)
						UIView.animateWithDuration(1, animations: {
							self.view.backgroundColor = UIColor.blueColor()
						})
					})

					self.asleep = !self.asleep
				}
			})
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		println(button.state)
		
		var request = HTTPTask()
		request.GET(baseUrlString + "status", parameters: nil, completionHandler: {(response: HTTPResponse) in
			
			if let err = response.error {
				println("error: \(err.localizedDescription)")
				return
			}
			
			if let data = response.responseObject as? NSData {
				let str = NSString(data: data, encoding: NSUTF8StringEncoding)
				
				println(str)
				
				if str! == "asleep" {
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.awakeText, forState: .Normal)
					})
					
					self.asleep = true
				} else {
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.asleepText, forState: .Normal)
					})

					self.asleep = false
				}
				
			}
		})
		
	}

}

