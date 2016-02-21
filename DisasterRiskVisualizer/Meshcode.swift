//
//  Meshcode.swift
//  DisasterRiskVisualizer
//
//  Created by hyuga on 2/21/16.
//  Copyright © 2016 CPS Lab. All rights reserved.
//

import UIKit
import CoreLocation

enum MeshScale {
	case Mesh1, Mesh2, Mesh3, Mesh4, Mesh5
}

class Meshcode {
	
	static func meshcodeToLatlng() {
		
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
		let e = (t % 7.5)
		
		let u = floor(lng - 100)
		let f = lng - 100 - floor(lng - 100)
		let v = floor(f * 60 / 7.5)
		let g = (f * 60 % 7.5)
		let w = floor(g * 60 / 45)
		let h = (g * 60 % 45)
		let x = floor(h / 22.5)
		let i = (h % 22.5)
		let y = floor(i / 11.25)
		let j = (i % 11.25)
		
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