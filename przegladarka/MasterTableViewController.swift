//
//  MasterTableViewController.swift
//  przegladarka
//
//  Created by dev on 25/10/2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

	var albums: [[String : Any]] = []
	
	func convertToDictionary(text: String) -> Any? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? Any
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let url = NSURL(string: "https://isebi.net/albums.php")
		if url != nil {
			let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
				if error == nil {
					
					let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
					if let contentDict = self.convertToDictionary(text: urlContent as! String ) as? [[String : Any]] {
						print(contentDict as Any)
						self.albums = contentDict
						DispatchQueue.main.async {
							self.tableView.reloadData()
						}
					}
				}
			})
			task.resume()
		}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return self.albums.count
	}

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		

		let titleLabel = cell.viewWithTag(1) as! UILabel
		let artistLabel = cell.viewWithTag(2) as! UILabel
		let yearLabel = cell.viewWithTag(3) as! UILabel
		
		if let albumName = albums[indexPath.row]["album"] {
			titleLabel.text = String (describing: albumName)
		} else {
			titleLabel.text = ""
		}
		if let artistName = albums[indexPath.row]["artist"] {
			artistLabel.text = String (describing: artistName)
		} else {
			artistLabel.text = ""
		}
		if let yearName = albums[indexPath.row]["year"] {
			yearLabel.text = String (describing: "(\(yearName))")
		} else {
			yearLabel.text = ""
		}
		// Configure the cell...
		
		return cell
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if(segue.identifier == "showDetails"){
			let dvc = segue.destination as! DetailViewController
			let selected = tableView.indexPathForSelectedRow
			
			dvc.album = albums[(selected?.row)!] as [String : AnyObject]
			dvc.curIndex = (selected?.row)!
		}
		
		if(segue.identifier == "deleteSegue"){
			let dvc = segue.source as! DetailViewController
			
			albums.remove(at: dvc.curIndex)
		}
    }


}
