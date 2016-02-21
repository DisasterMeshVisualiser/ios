//
//  ViewController.swift
//  DisasterRiskVisualizer
//
//  Created by hyuga on 2/21/16.
//  Copyright © 2016 CPS Lab. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

	var googleMap: GMSMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		googleMap = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
		
		self.view.addSubview(googleMap)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

