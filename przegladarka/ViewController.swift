//
//  ViewController.swift
//  przegladarka
//
//  Created by Użytkownik Gość on 10.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var tracksField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var albumNumberLabel: UILabel!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var currentID = 0
    
	let delegate = UIApplication.shared.delegate as! AppDelegate
	var albums: [[String : Any]] = []
	
	//pasted from https://stackoverflow.com/questions/41163026/how-to-convert-json-string-into-array-of-dictionaries-in-ios-swift-3
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
    
    func updateView(){

			artistField.text = String (describing: (albums[currentID]["artist"])!)
			titleField.text = String (describing: (albums[currentID]["album"])!)
			genreField.text = String (describing: (albums[currentID]["genre"])!)
			yearField.text = String (describing: (albums[currentID]["year"])!)
			tracksField.text = String (describing: (albums[currentID]["tracks"])!)
            
            albumNumberLabel.text = "Album \(currentID+1) z \(albums.count)"
            
            switch currentID {
            case 0:
                prevButton.isEnabled = false
            default:
                nextButton.isEnabled = true
                prevButton.isEnabled = true
            }
		saveButton.isEnabled = true
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
							self.updateView()
						}
					}
				}
			})
			task.resume()
		}
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextAlbum(_ sender: UIButton) {
		currentID += 1
		updateView()
    }
    @IBAction func prevAlbum(_ sender: UIButton) {
		currentID -= 1
		updateView()
    }
	@IBAction func updateAlbum(_ sender: UIButton) {
		albums[currentID]["artist"] = artistField.text!
		albums[currentID]["album"] = titleField.text!
		albums[currentID]["genre"] = genreField.text!
		albums[currentID]["year"] = yearField.text!
		albums[currentID]["tracks"] = tracksField.text!
	}
}

