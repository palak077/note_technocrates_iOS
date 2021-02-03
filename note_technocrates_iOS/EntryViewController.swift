//
//  EntryViewController.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-27.
//

import UIKit

class EntryViewController: UIViewController {
    
    //outlet to show the heading of the note and the note itself
    @IBOutlet var titleField : UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion :((String, String)  -> Void)?
    //add this completion handler to the other VC that shows this VC, when user tap save we are gonna call it

    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        //keyboard with auto focus, it should b the first responder
        //add the save button which is the right button of type UIBarButton on the bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    @objc func didTapSave()
    {
        //make sure there is text in the titleField and also that it is not empty and then call completion handler
        if let text = titleField.text,!text.isEmpty, !noteField.text.isEmpty
        {
            completion?(text,noteField.text)
        }
    }

}
