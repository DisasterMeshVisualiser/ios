//
//  LayerSelectViewController.swift
//  DisasterRiskVisualizer
//
//  Created by hyuga on 3/3/16.
//  Copyright © 2016 CPS Lab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol LayerSelectDelegate {
	func didSelectedLayer(meshTypes: [MeshType])
}

class LayerSelectViewController: UITableViewController {
	var meshTypes = [MeshType]()
	var delegate: LayerSelectDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
		
		title = "表示するデータを選択"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTapped")
		reload()
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("dataListCell")!
		cell.textLabel?.text = meshTypes[indexPath.row].label
		return cell
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meshTypes.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		cell?.accessoryType = .Checkmark
	}
	
	override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		cell?.accessoryType = .None
	}
	
	func reload() {
		self.meshTypes.removeAll()
		Alamofire.request(.GET, "http://www.ninten320.com/datalist.json").response { (request, response, data, error) -> Void in
			guard let data = data else { return }
			var jsonData = JSON(data: data)
			for (_, subJson) in jsonData["data"]{
				let label = subJson["label"].stringValue
				let name = subJson["name"].stringValue
				let meshType = MeshType(name: name, label: label)
				self.meshTypes.append(meshType)
			}
			self.tableView.reloadData()
		}
	}
	
	func doneButtonTapped() {
		var selectedData = [MeshType]()
		for i in 0..<tableView.numberOfRowsInSection(0) {
			let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
			if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
				selectedData.append(meshTypes[i])
			}
		}
		(navigationController?.viewControllers[0] as! MapViewController).meshTypes = selectedData
		navigationController?.popViewControllerAnimated(true)
	}
}