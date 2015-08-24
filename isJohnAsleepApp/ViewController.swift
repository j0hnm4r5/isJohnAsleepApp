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
	
	let baseUrlString = "http://isjohnasleep.m4r5.io/"
//	let baseUrlString = "http://192.168.1.100:3000/"
	
	let awakeColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
	let asleepColor = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)

	@IBOutlet weak var button: UIButton!
	@IBAction func buttonPress(sender: AnyObject) {
		
		let request = HTTPTask()
		
		if asleep {
			request.POST(baseUrlString + "awake", parameters: nil, completionHandler: {(response: HTTPResponse) in
				
				if let err = response.error {
					print("error: \(err.localizedDescription)")
					return
				}
				
				if let data = response.responseObject as? NSData {
					let str = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(str!)
					
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.asleepText, forState: .Normal)
						UIView.animateWithDuration(1, animations: {
							self.view.backgroundColor = self.asleepColor
						})
					})

					self.asleep = !self.asleep
				}
			})
		} else {
			request.POST(baseUrlString + "asleep", parameters: nil, completionHandler: {(response: HTTPResponse) in
				
				if let err = response.error {
					print("error: \(err.localizedDescription)")
					return
				}
				
				if let data = response.responseObject as? NSData {
					let str = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(str!)
					
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.awakeText, forState: .Normal)
						UIView.animateWithDuration(1, animations: {
							self.view.backgroundColor = self.awakeColor
						})
					})

					self.asleep = !self.asleep
				}
			})
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(button.state)
		
		let request = HTTPTask()
		request.GET(baseUrlString + "status", parameters: nil, completionHandler: {(response: HTTPResponse) in
			
			if let err = response.error {
				print("error: \(err.localizedDescription)")
				return
			}
			
			if let data = response.responseObject as? NSData {
				let str = NSString(data: data, encoding: NSUTF8StringEncoding)
				
				print(str)
				
				if str! == "asleep" {
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.awakeText, forState: .Normal)
						self.view.backgroundColor = self.awakeColor
					})
					
					self.asleep = true
				} else {
					dispatch_async(dispatch_get_main_queue(), {
						self.button.setTitle(self.asleepText, forState: .Normal)
						self.view.backgroundColor = self.asleepColor
					})

					self.asleep = false
				}
				
			}
		})
		
	}

}

