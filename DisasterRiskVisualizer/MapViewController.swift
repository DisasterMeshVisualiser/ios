//
//  MapViewController.swift
//  DisasterRiskVisualizer
//
//  Created by hyuga on 2/21/16.
//  Copyright © 2016 CPS Lab. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
	
	@IBOutlet weak var googleMap: GMSMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let target = CLLocationCoordinate2DMake(35.7, 139.65)
		let camera = GMSCameraPosition.cameraWithTarget(target, zoom: 16)
		googleMap.camera = camera
		googleMap.myLocationEnabled = true
		googleMap.settings.myLocationButton = true
	}
}