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
		
		let rect = GMSMutablePath()
		for latlng in Meshcode.meshcodeToLatlng(meshcode) {
			rect.addCoordinate(latlng)
		}
		
		let polygon = GMSPolygon(path: rect)
		polygon.fillColor = UIColor(red:0.25, green:0, blue:0, alpha:0.5);
		polygon.strokeColor = UIColor.redColor()
		polygon.strokeWidth = 2
		polygon.map = mapView
	}
	
}