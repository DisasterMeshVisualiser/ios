//
//  Meshcode.swift
//  DisasterRiskVisualizer
//
//  Created by hyuga on 2/21/16.
//  Copyright © 2016 CPS Lab. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

enum MeshScale {
	case Mesh1, Mesh2, Mesh3, Mesh4, Mesh5
}

class Meshcode {
	
	static func meshcodeToRegion(meshcode: String, scale: MeshScale) -> GMSVisibleRegion {
		let length = meshcode.characters.count
		var lat = 0.0
		var lng = 0.0
		let a = Double((meshcode as NSString).substringWithRange(NSRange(location: 0, length: 2)))!
		let d = Double((meshcode as NSString).substringWithRange(NSRange(location: 2, length: 2)))!
		lat = a / 1.5
		lng = d + 100
		if (length == 4 || scale == .Mesh1) {
			return calcRegion(lat: lat, lng: lng, latD: 2.0 / 3, lngD: 1)
		}
		let b = Double((meshcode as NSString).substringWithRange(NSRange(location: 4, length: 1)))!
		let e = Double((meshcode as NSString).substringWithRange(NSRange(location: 5, length: 1)))!
		lat += b * 5 / 60
		lng += e * 7.5 / 60
		if (length == 6 || scale == .Mesh2) {
			return calcRegion(lat: lat, lng: lng, latD: 5.0 / 60, lngD: 7.5 / 60)
		}
		let c = Double((meshcode as NSString).substringWithRange(NSRange(location: 6, length: 1)))!
		let f = Double((meshcode as NSString).substringWithRange(NSRange(location: 7, length: 1)))!
		lat += c * 30 / 3600
		lng += f * 45 / 3600
		if (length == 8 || scale == .Mesh3) {
			return calcRegion(lat: lat, lng: lng, latD: 30.0 / 3600, lngD: 45.0 / 3600)
		}
		let g = Double((meshcode as NSString).substringWithRange(NSRange(location: 8, length: 1)))!
		if g == 3 || g == 4 {
			lat += 15.0 / 3600
		}
		if g == 2 || g == 4 {
			lng += 22.5 / 3600
		}
		if (length == 9 || scale == .Mesh4) {
			return calcRegion(lat: lat, lng: lng, latD: 15.0 / 3600, lngD: 22.5 / 3600)
		}
		let h = Double((meshcode as NSString).substringWithRange(NSRange(location: 9, length: 1)))!
		if h == 3 || h == 4 {
			lat += 7.5 / 3600
		}
		if h == 2 || h == 4 {
			lng += 11.25 / 3600
		}
		if (length == 10 || scale == .Mesh5) {
			return calcRegion(lat: lat, lng: lng, latD: 7.5 / 3600, lngD: 11.25 / 3600)
		}
		return GMSVisibleRegion()

	}
	
	private static func calcRegion(lat lat: Double, lng: Double, latD: Double, lngD: Double) -> GMSVisibleRegion {
		let nearLeft = (CLLocationCoordinate2DMake(lat, lng))
		let farLeft = (CLLocationCoordinate2DMake(lat + latD, lng))
		let farRight = (CLLocationCoordinate2DMake(lat + latD, lng + lngD))
		let nearRight = (CLLocationCoordinate2DMake(lat, lng + lngD))
		return GMSVisibleRegion(nearLeft: nearLeft, nearRight: nearRight, farLeft: farLeft, farRight: farRight)
	}
	
	static func latlngToMeshcode(coordinate: CLLocationCoordinate2D, scale: MeshScale) -> String {
		let lat = coordinate.latitude
		let lng = coordinate.longitude
		let p = floor(lat * 60 / 40)
		let a = (lat * 60 % 40)
		let q = floor(a / 5)
		let b = (a % 5)
		let r = floor(b * 60 / 30)
		let c = (b * 60 % 30)
		let s = floor(c / 15)
		let d = (c % 15)
		let t = floor(d / 7.5)
//		let e = (t % 7.5)
		
		let u = floor(lng - 100)
		let f = lng - 100 - floor(lng - 100)
		let v = floor(f * 60 / 7.5)
		let g = (f * 60 % 7.5)
		let w = floor(g * 60 / 45)
		let h = (g * 60 % 45)
		let x = floor(h / 22.5)
		let i = (h % 22.5)
		let y = floor(i / 11.25)
//		let j = (i % 11.25)
		
		let m = (s * 2) + (x + 1)
		let n = (t * 2) + (y + 1)
		
		switch scale {
		case .Mesh1:
			return "\(Int(p))\(Int(u))"
		case .Mesh2:
			return "\(Int(p))\(Int(u))\(Int(q))\(Int(v))"
		case .Mesh3:
			return "\(Int(p))\(Int(u))\(Int(q))\(Int(v))\(Int(r))\(Int(w))"
		case .Mesh4:
			return "\(Int(p))\(Int(u))\(Int(q))\(Int(v))\(Int(r))\(Int(w))\(Int(m))"
		case .Mesh5:
			return "\(Int(p))\(Int(u))\(Int(q))\(Int(v))\(Int(r))\(Int(w))\(Int(m))\(Int(n))"
		}
	}
}

extension GMSVisibleRegion {
	var farLeftMesh: String {
		return Meshcode.latlngToMeshcode(farLeft, scale: MeshScale.Mesh5)
	}
	var farRightMesh: String {
		return Meshcode.latlngToMeshcode(farRight, scale: MeshScale.Mesh5)
	}
	var nearLeftMesh: String {
		return Meshcode.latlngToMeshcode(nearLeft, scale: MeshScale.Mesh5)
	}
	var nearRightMesh: String {
		return Meshcode.latlngToMeshcode(nearRight, scale: MeshScale.Mesh5)
	}
}