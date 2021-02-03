//
//  ViewController.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-27.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var table: UITableView!
    //to show notes in one table
    @IBOutlet var label: UILabel!
    //to show no notes text if there are no notes
    
    var models : [(title: String, note : String)] = []
    //array of tuples showing note heading and note , initially empty
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        //assigning the delegate as well as datasource to this view
        
        title = "Notes"
        //title for the screen
        
    }
    //MARK: - action when user wants to add new note
    @IBAction func didTapNewNote()
    {
        guard  let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController  else
        {
            return
        }
        vc.title = "New Note"
        // to make app look little nicer
        vc.navigationItem.largeTitleDisplayMode = .never
        
        //assign the completion
        vc.completion = { noteTitle, note in
            self.navigationController?.popViewController(animated: true)
            self.models.append((title : noteTitle, note :note))
            //when we have notes in models array , we will hide the label that says no notes yet and show the table
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return models.count
        //number of rows I want is the number of things in models array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //to deque the cell from the table view , the id is cell
        cell.textLabel?.text = models[indexPath.row].title
        //text for cell label is models at index .title
        // title will come in the text label and the full note will come in the detailText
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    //MARK: - action when user select a particular note
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        //deselect the row when user tap on a paritcular note because we are going to the next VC
        
        //the note at the current position(indexpath) of the row is passed to the model variable to pass to next view controller
        let model = models[indexPath.row]
        
        //show note controller
        //instantiate the view controller from the storyboard with  id=note
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else{
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        //the saved values in the array are passed to next vc
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated : true)
    }

}

