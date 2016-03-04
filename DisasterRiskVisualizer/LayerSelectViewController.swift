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

class LayerSelectViewController: UITableViewController {
	var datalist = [DRVApi]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
		
		title = "表示するデータを選択"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "closeTable")
		reload()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("dataListCell")
		cell?.textLabel?.text = datalist[indexPath.row].label
		return cell!
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return datalist.count
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
		Alamofire.request(.GET, "http://www.ninten320.com/datalist.json").response { (request, response, data, error) -> Void in
			self.datalist.removeAll()
			if let data = data {
				var jsonData = JSON(data: data)
				for (_, subJson) in jsonData["data"]{
					let label = subJson["label"].stringValue
					let name = subJson["label"].stringValue
					let api = DRVApi(name: name, label: label)
					self.datalist.append(api)
				}
				self.tableView.reloadData()
			}
		}
	}
	
	func closeTable() {
		var selectedData = [String]()
		for i in 0..<tableView.numberOfRowsInSection(0) {
			let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
			if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
				selectedData.append(datalist[i].label)
			}
		}
		print(selectedData)
		navigationController?.popViewControllerAnimated(true)
		
	}
}