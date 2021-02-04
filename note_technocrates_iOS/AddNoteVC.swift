//
//  AddNoteVC.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-27.
//


import UIKit
import CoreData
import MapKit
import CoreLocation

class AddNoteVC: UIViewController , CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{

    var dataManager : NSManagedObjectContext!;
    var listArray = [NSManagedObject]();
    var locationManager: CLLocationManager!
    var lat: Double!
    var long: Double!
    var strTitle: String!
    var strDescription: String!
    var timestamp: Int64!
    var pickerData: [String] = [String]()
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var locationTF: UILabel!
    @IBOutlet weak var descTF: UITextView!
    @IBOutlet weak var AddPhotoBTN: UIButton!
    @IBOutlet weak var RemovePhotoBTN: UIButton!

    @IBOutlet weak var categoryTF: UITextField!
       
       @IBOutlet weak var selectFromList: UIButton!
       
       @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var btnAudio: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.RemovePhotoBTN.isHidden =  true
        imageView.isHidden =  true

        //refernce for the managed context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
              dataManager = appDelegate.persistentContainer.viewContext;
              pickerData = ["Work", "Home", "School", "Michelenous", "Sports", "Others"]
        
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        categoryPicker.isHidden = true;
        categoryTF.text = "Work"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            
           //if error - do dismissKeyboard only
           //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
           //tap.cancelsTouchesInView = false

           view.addGestureRecognizer(tap)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        timestamp = Date().currentTimeMillis();

        // Do any additional setup after loading the view.
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation

        /* you can use these values*/
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
//        print(self.lat as Any);
//        print(self.long as Any);
//        print(timestamp as Any);
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark?

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
          if error != nil {
//            print("something went horribly wrong")
          }
          if let placemarks = placemarks {
            placemark = placemarks.first
            DispatchQueue.main.async {
//              self.locationTF.text = (placemark?.locality!)
                self.locationTF.text = ""

            }
        }
    }
    }
    
    //MARK: - working of add button to add notes into the database
    @IBAction func AddBTN(_ sender: UIBarButtonItem)
    {
         timestamp = Date().currentTimeMillis();
      
         strTitle = titleTF.text;
         strDescription = descTF.text;
        //if statement to make sure that user entered the title of the note, else showdialog()
        if (strTitle != "")
        {
            //enter data into the notes
            let notesEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: dataManager);

            //create a notesEntity object
            notesEntity.setValue(strTitle, forKey: "title")
            notesEntity.setValue(categoryTF.text, forKey: "category")
            notesEntity.setValue(strDescription, forKey: "desc")
            notesEntity.setValue(timestamp, forKey: "created")

            print(timestamp)

            notesEntity.setValue(lat, forKey: "latitude")
            notesEntity.setValue(long, forKey: "longitude")
            if !(imageData.isEmpty){
                notesEntity.setValue(imageData, forKey: "imageData")
            }
            //to catch error while saving
            do
            {
                try self.dataManager.save()
                listArray.append(notesEntity);
            }
            catch
            {
                print ("Error saving data")
            }
        }
        else
        {
           showDialog();
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    func showDialog()
    {
        let alert = UIAlertController(title: "NoteIt", message: "Please add title of the note.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK: - add image with the notes
    @IBAction func Addphoto_BTN(_ sender: UIButton)
    {
        openDialog();
        //to select image from camera or gallery
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//               var imagePicker = UIImagePickerController()
//               imagePicker.delegate = self
//               imagePicker.sourceType = .camera;
//               imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//           }
        
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Button capture")
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//        }
    }
    
//    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary;
//            imagePicker.allowsEditing = true
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imageView.isHidden =  false
            self.imageView.image = image
            self.RemovePhotoBTN.isHidden =  false
            self.AddPhotoBTN.isHidden =  true
            imageData = image.pngData()!
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - to delete the image attached
    @IBAction func RemovePhoto_BTN(_ sender: UIButton) {
        self.AddPhotoBTN.isHidden =  false
        self.RemovePhotoBTN.isHidden =  true
        self.imageView.isHidden =  true

    }
    //MARK: - select the category of the notes
    @IBAction func selectCategoryBTN(_ sender: UIButton)
    {
        print("cat selected")
        self.categoryPicker.isHidden = false;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
     }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryPicker.isHidden = true;
        categoryTF.text = pickerData[row]
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //MARK: - to pick the image either from the gallery or using phone camera
    func openDialog()
    {
           let alert = UIAlertController(title: "NoteIt!", message: "Pick image from", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                 if UIImagePickerController.isSourceTypeAvailable(.camera)
                 {
                           var imagePicker = UIImagePickerController()
                           imagePicker.delegate = self
                           imagePicker.sourceType = .camera;
                           imagePicker.allowsEditing = false
                        self.present(imagePicker, animated: true, completion: nil)
                       }
           }))
           alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
                     if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                     {
                         var imagePicker = UIImagePickerController()
                         imagePicker.delegate = self
                         imagePicker.sourceType = .photoLibrary;
                         imagePicker.allowsEditing = true
                         self.present(imagePicker, animated: true, completion: nil)
                     }
                 
           }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           self.present(alert, animated: true)
       }
}




//delete the note - trailing method - lecture 3 - 16.00 or appllo notes
//edit the note
//apple docs on the way to enter data into the core data
//relationship of the notes with category to put them in the particular category

