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
	
	var selectedPolyLine: GMSPolyline?
	var selectedMarker: GMSMarker?
	var selectedMeshCode: String?
	
	var latlngLines = [GMSPolyline]()
	var detailLatlngLines = [GMSPolyline]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		googleMap.delegate = self
		
		let target = CLLocationCoordinate2DMake(38.258595, 137.6850225)
		let camera = GMSCameraPosition.cameraWithTarget(target, zoom: 4.5)
		googleMap.camera = camera
		googleMap.myLocationEnabled = true
		googleMap.settings.myLocationButton = true
		googleMap.setMinZoom(4, maxZoom: 21)
		googleMap.settings.rotateGestures = false
		googleMap.settings.indoorPicker = false
		googleMap.settings.tiltGestures = false
	}
	
	func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
		for line in latlngLines {
			line.map = nil
		}
		latlngLines.removeAll()
		if position.zoom >= 14 {
			createLatLngLine()
		}
		reloadLines()
	}
	
	func createLatLngLine() {
		let region = googleMap.projection.visibleRegion()
		let minLat = region.nearLeft.latitude
		let maxLat = region.farRight.latitude
		let minLng = region.nearLeft.longitude
		let maxLng = region.farRight.longitude
		
		for i in 122 * 320...154 * 320 {
			if Double(i) / 320 < minLng - 0.05 { continue }
			if maxLng < Double(i) / 320 { continue }
			let path = GMSMutablePath()
			path.addCoordinate(CLLocationCoordinate2DMake(minLat - 1, Double(i) / 320))
			path.addCoordinate(CLLocationCoordinate2DMake(maxLat + 1, Double(i) / 320))
			let line = GMSPolyline(path: path)
			line.strokeColor = UIColor.brownColor()
			line.strokeWidth = 1
			line.map = googleMap
			latlngLines.append(line)
		}
		for i in 20 * 480...46 * 480 {
			if Double(i) / 480 < minLat { continue }
			if maxLat < Double(i) / 480 { continue }
			let path = GMSMutablePath()
			path.addCoordinate(CLLocationCoordinate2DMake(Double(i) / 480, minLng - 1))
			path.addCoordinate(CLLocationCoordinate2DMake(Double(i) / 480, maxLng + 1))
			let line = GMSPolyline(path: path)
			line.strokeColor = UIColor.brownColor()
			line.strokeWidth = 1
			line.map = googleMap
			latlngLines.append(line)
		}
	}
	
	func reloadLines() {
		guard let meshcode = selectedMeshCode else {
			selectedPolyLine?.map = nil
			return
		}
		selectedPolyLine?.map = nil
		if googleMap.camera.zoom < 14 {
			return
		}
		var latlng = Meshcode.meshcodeToLatlng(meshcode, scale: .Mesh5)
		let path = GMSMutablePath()
		path.addCoordinate(latlng[0])
		path.addCoordinate(latlng[1])
		path.addCoordinate(latlng[2])
		path.addCoordinate(latlng[3])
		path.addCoordinate(latlng[0])
		
		selectedPolyLine = GMSPolyline(path: path)
		selectedPolyLine?.strokeColor = UIColor.redColor()
		selectedPolyLine?.strokeWidth = 5
		selectedPolyLine?.map = googleMap
	}
	
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		let meshcode = Meshcode.latlngToMeshcode(coordinate, scale: MeshScale.Mesh5)
		if selectedMeshCode == meshcode {
			selectedMeshCode = nil
		} else {
			selectedMeshCode = meshcode
		}
		print(meshcode)
		
		reloadLines()
		
	}
	
}