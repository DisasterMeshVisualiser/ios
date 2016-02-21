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

class MapViewController: UIViewController, GMSMapViewDelegate {
	
	@IBOutlet weak var googleMap: GMSMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		googleMap.delegate = self
		
		let target = CLLocationCoordinate2DMake(35.7, 139.65)
		let camera = GMSCameraPosition.cameraWithTarget(target, zoom: 14)
		googleMap.camera = camera
		googleMap.myLocationEnabled = true
		googleMap.settings.myLocationButton = true
	}
	
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		let meshcode = Meshcode.latlngToMeshcode(coordinate, scale: MeshScale.Mesh5)
		let marker = GMSMarker(position: coordinate)
		marker.snippet = "\(coordinate.latitude),\(coordinate.longitude)"
		marker.title = meshcode
		marker.map = googleMap
	}
	
}