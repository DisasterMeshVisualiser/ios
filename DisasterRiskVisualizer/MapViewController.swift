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
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, GMSMapViewDelegate {
	
	@IBOutlet weak var googleMap: GMSMapView!
	@IBOutlet weak var toolbar: UIToolbar!
	
	var meshTypes = [MeshType]()
	
	var selectedPolyLine: GMSPolyline?
	var selectedMarker: GMSMarker?
	var selectedMeshCode: String?
	
	var latlngLines = [GMSPolyline]()
	var detailLatlngLines = [GMSPolyline]()
	
	var meshPolygons = [GMSPolygon]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		toolbar.tintColor = UIColor.blackColor()
		toolbar.barTintColor = UIColor.lightGrayColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
		googleMap.delegate = self
		let target = CLLocationCoordinate2DMake(35.748519, 139.80354)
		let camera = GMSCameraPosition.cameraWithTarget(target, zoom: 15)
		googleMap.camera = camera
		googleMap.myLocationEnabled = true
		googleMap.settings.myLocationButton = true
		googleMap.setMinZoom(14, maxZoom: 22)
		googleMap.settings.rotateGestures = false
		googleMap.settings.indoorPicker = false
		googleMap.settings.tiltGestures = false
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		loadMeshData()
	}
	
	func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
		createLatLngLine()
		reloadLines()
	}
	
	func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
		resetCameraPosition(position)
		createLatLngLine()
		reloadLines()
	}
	
	func loadMeshData() {
		for polygon in meshPolygons {
			polygon.map = nil
		}
		meshPolygons.removeAll()
		for meshType in meshTypes {
			Alamofire.request(.GET, "http://mesh.cps.im.dendai.ac.jp/api/v1/mesh.json?mesh_type=\(meshType.id)").response { (request, response, data, error) -> Void in
				guard let data = data else { return }
				var jsonData = JSON(data: data)
				for (_, subJson) in jsonData["data"]{
					let meshcode = subJson["meshcode"].stringValue
					var region = Meshcode.meshcodeToRegion(meshcode, scale: .Mesh5)
					let value = subJson["value"].doubleValue
					self.showMeshData(region, value: value * 2)
					print(meshcode)
					print(value)
				}
			}
		}
	}
	
	func showMeshData(region: GMSVisibleRegion, value: Double) {
		let path = GMSMutablePath()
		path.addCoordinate(region.farLeft)
		path.addCoordinate(region.farRight)
		path.addCoordinate(region.nearRight)
		path.addCoordinate(region.nearLeft)

		let polygon = GMSPolygon(path: path)
		polygon.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: CGFloat(value))
		polygon.map = googleMap
		meshPolygons.append(polygon)
	}
	
	func resetCameraPosition(position: GMSCameraPosition) {
		var targetLat = position.target.latitude
		var targetLng = position.target.longitude
		
		if targetLat < 20 {
			targetLat = 20
		}
		if 46 < targetLat {
			targetLat = 46
		}
		if targetLng < 122 {
			targetLng = 122
		}
		if 156 < targetLng {
			targetLng = 156
		}
		googleMap.animateToLocation(CLLocationCoordinate2DMake(targetLat, targetLng))
	}
	
	
	func createLatLngLine() {
		for line in latlngLines {
			line.map = nil
		}
		latlngLines.removeAll()
		if googleMap.camera.zoom < 14 {
			return
		}
		let region = googleMap.projection.visibleRegion()
		let minLat = region.nearLeft.latitude
		let maxLat = region.farRight.latitude
		let minLng = region.nearLeft.longitude
		let maxLng = region.farRight.longitude
		
		for i in 122 * 320...154 * 320 {
			if Double(i) / 320 < minLng - 0.05 { continue }
			if maxLng + 0.05 < Double(i) / 320 { continue }
			let path = GMSMutablePath()
			path.addCoordinate(CLLocationCoordinate2DMake(max(minLat - 1, 20), Double(i) / 320))
			path.addCoordinate(CLLocationCoordinate2DMake(min(maxLat + 1, 46), Double(i) / 320))
			let line = GMSPolyline(path: path)
			line.strokeColor = UIColor.brownColor()
			line.strokeWidth = 1
			line.map = googleMap
			latlngLines.append(line)
		}
		for i in 20 * 480...46 * 480 {
			if Double(i) / 480 < minLat - 0.05 { continue }
			if maxLat + 0.05 < Double(i) / 480 { continue }
			let path = GMSMutablePath()
			path.addCoordinate(CLLocationCoordinate2DMake(Double(i) / 480, max(minLng - 1, 122.0)))
			path.addCoordinate(CLLocationCoordinate2DMake(Double(i) / 480, min(maxLng + 1, 154.0)))
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
		let region = Meshcode.meshcodeToRegion(meshcode, scale: .Mesh5)
		let path = GMSMutablePath()
		path.addCoordinate(region.farLeft)
		path.addCoordinate(region.farRight)
		path.addCoordinate(region.nearRight)
		path.addCoordinate(region.nearLeft)
		path.addCoordinate(region.farLeft)
		
		selectedPolyLine = GMSPolyline(path: path)
		selectedPolyLine?.strokeColor = UIColor.redColor()
		selectedPolyLine?.strokeWidth = 5
		selectedPolyLine?.map = googleMap
	}
	
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		selectedMeshCode = nil
		if coordinate.latitude < 20 || 46 < coordinate.latitude {
			return
		}
		if coordinate.longitude < 122 || 156 < coordinate.longitude {
			return
		}
		
		let meshcode = Meshcode.latlngToMeshcode(coordinate, scale: MeshScale.Mesh5)
		selectedMeshCode = meshcode
		print(meshcode)
		
		reloadLines()
		
	}
	
}