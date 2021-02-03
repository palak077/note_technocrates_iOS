//
//  NoteViewController.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-27.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var noteLabel : UITextView!
    
    public var noteTitle : String = ""
    public var  note :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = note

    }
}
