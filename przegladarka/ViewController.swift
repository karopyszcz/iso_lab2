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
	var albums: [[String : Any]] = []

    
    func updateView(){
		if (albums.count == 0) {
			(titleField.text, artistField.text, genreField.text, yearField.text, tracksField.text) = ("", "", "", "", "")
			albumNumberLabel.text = "Brak albumów"
			(nextButton.isEnabled, prevButton.isEnabled, deleteButton.isEnabled) = (false, false, false)
		} else {
			artistField.text = String (describing: (albums[currentID]["artist"])!)
			titleField.text = String (describing: (albums[currentID]["album"])!)
			genreField.text = String (describing: (albums[currentID]["genre"])!)
			yearField.text = String (describing: (albums[currentID]["year"])!)
			tracksField.text = String (describing: (albums[currentID]["tracks"])!)
			albumNumberLabel.text = "Rekord \(currentID+1) z \(albums.count)"
		
			switch currentID {
			case 0:
				prevButton.isEnabled = false
			default:
				nextButton.isEnabled = true
				prevButton.isEnabled = true
			}
			saveButton.isEnabled = false
		}
    }


	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextAlbum(_ sender: UIButton) {
		if (currentID < albums.count-1){
			currentID += 1
			updateView()
		} else {
			initAlbum()
		}
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
		updateView()
	}
	
	@IBAction func deleteAlbum(_ sender: UIButton) {
		albums.remove(at: self.currentID)
		if (currentID >= albums.count) {
			currentID -= 1
		}
		updateView()
	}
	
	@IBAction func addAlbum(_ sender: UIButton) {
		initAlbum()
	}
    
    func initAlbum(){
		nextButton.isEnabled = false
		
        currentID = albums.count
        (artistField.text, titleField.text, genreField.text, yearField.text, tracksField.text) = ("", "", "", "", "")
        albumNumberLabel.text = "Nowy rekord"
        let emptyString = "" as AnyObject
        albums.append(
            ["artist":emptyString, "album":emptyString, "genre":emptyString, "year":emptyString, "tracks":emptyString]
        )
    }
    
    @IBAction func editedField(_ sender: UITextField) {
        saveButton.isEnabled=true
    }
}

