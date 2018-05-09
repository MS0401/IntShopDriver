//
//  AccountViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import Photos
import AAViewAnimator

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var photoIcon: UIImageView!
    @IBOutlet var vehicleImage: UIImageView!
    @IBOutlet var countryCode: UILabel!
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var dropDownVehicleView: UIView!
    @IBOutlet var pageFlowView: PagedFlowView!
    @IBOutlet var birthdaydd: DateFieldTextField!
    @IBOutlet var birthdaymm: DateFieldTextField!
    @IBOutlet var birthdayaa: DateFieldTextField!
    @IBOutlet var creditdd: DateFieldTextField!
    @IBOutlet var creditmm: DateFieldTextField!
    @IBOutlet var creditaa: DateFieldTextField!
    @IBOutlet var expirationdd: DateFieldTextField!
    @IBOutlet var expirationmm: DateFieldTextField!
    @IBOutlet var expirationaa: DateFieldTextField!
    
    @IBOutlet var licenseTypeTxt: UITextField!
    
    
    
    
    
    
    var selectedCountry: Country!
    // ImagePickerController property
    let imagePicker = UIImagePickerController()
    var flag: Bool = true
    
    let vehicleTypes = ["Bike", "Bycicle", "Family", "Sedan", "Car", "Truck", "Suv", "Van"]
    let vehicleImages = ["car_bike", "car_bycicle", "car_family", "car_sedan", "car_smallcar", "car_smalltruck", "car_suv", "car_van"]
    let licenseTypes = ["Full UK", "European", "CBT", "No License"]
    
    var activeTF : UITextField!
    var picker : UIPickerView!
    var activeValue = ""
    
    var delegate: CreateAccountDelegate?
    
    //MARK: Location Manager - CoreLocation Framework.
    var locationManager = CLLocationManager()
    
    //MARK: Current location information
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Initialize()
                
    }
    
    
    func Initialize() {
        
        //MARK: DateFieldTextField
        self.birthdayaa.dateDelegate = self
        self.birthdayaa.datetype = .date
        self.birthdayaa.doneButtonTint = UIColor.blue
        self.birthdaydd.dateDelegate = self
        self.birthdaydd.datetype = .date
        self.birthdaydd.doneButtonTint = UIColor.blue
        self.birthdaymm.dateDelegate = self
        self.birthdaymm.datetype = .date
        self.birthdaymm.doneButtonTint = UIColor.blue
        
        self.creditdd.dateDelegate = self
        self.creditdd.datetype = .date
        self.creditdd.doneButtonTint = UIColor.blue
        self.creditmm.dateDelegate = self
        self.creditmm.datetype = .date
        self.creditmm.doneButtonTint = UIColor.blue
        self.creditaa.dateDelegate = self
        self.creditaa.datetype = .date
        self.creditaa.doneButtonTint = UIColor.blue
        
        self.expirationdd.dateDelegate = self
        self.expirationdd.datetype = .date
        self.expirationdd.doneButtonTint = UIColor.blue
        self.expirationmm.dateDelegate = self
        self.expirationmm.datetype = .date
        self.expirationmm.doneButtonTint = UIColor.blue
        self.expirationaa.dateDelegate = self
        self.expirationaa.datetype = .date
        self.expirationaa.doneButtonTint = UIColor.blue
        
        self.dropDownVehicleView.isHidden = true
        
        self.pageFlowView.delegate = self
        self.pageFlowView.dataSource = self
        self.pageFlowView.minimumPageAlpha = 0.4
        self.pageFlowView.minimumPageScale = 0.8
        self.pageFlowView.orientation = PagedFlowViewOrientationHorizontal
        
        self.avatarImage.image = UIImage(named: "avatar_placeholder")
        self.avatarImage.layer.borderWidth = 2
        self.avatarImage.layer.borderColor = UIColor.init(netHex: 0x3493d5).cgColor
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.height/2
        self.avatarImage.layer.masksToBounds = true
        
        
        self.licenseTypeTxt.delegate = self
        
    }
    
    @IBAction func GettingPhotoAction(_ sender: UIButton) {
        
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.imagePicker.modalPresentationStyle = .popover
                self.imagePicker.sourceType = .photoLibrary// or savedPhotoAlbume
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UIImagePickerContollerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.avatarImage.backgroundColor = UIColor.clear
            self.avatarImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SelectVehicleType(_ sender: UIButton) {
        
        if flag {
            self.flag = false
            UIView.transition(with: self.dropDownVehicleView, duration: 1, options: .transitionFlipFromLeft, animations: { self.dropDownVehicleView.isHidden = false }, completion: nil)
            //self.animateWithTransition(.fromLeft)
            
            
        } else {
            self.flag = true
            UIView.transition(with: self.dropDownVehicleView, duration: 1, options: .transitionFlipFromRight, animations: { self.dropDownVehicleView.isHidden = true }, completion: nil)
            // self.animateWithTransition(.toRight)
            
        }
    }
    @IBAction func GettingCountryCodeAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "countrycode1", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countrycode1" {
            if let control = segue.destination as? UINavigationController {
                if let contrl = control.topViewController as? SRCountryPickerController {
                    contrl.countryDelegate = self
                }
            }
        }else if segue.identifier == "setting" {
            
            _ = segue.destination as! SettingsViewController
        }else if segue.identifier == "about" {
            _ = segue.destination as! AboutViewController
        }else if segue.identifier == "help" {
            _ = segue.destination as! HelpViewController
        }
    }
    @IBAction func GotoSetting(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "setting", sender: self)
    }
    
    @IBAction func GotoAbout(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "about", sender: self)
    }
    
    @IBAction func GotoHelp(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "help", sender: self)
    }
    
    
    
    // show picker view
    func pickUpValue(textField: UITextField) {
        
        // create frame and size of picker view
        picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        
        // deletates
        picker.delegate = self
        picker.dataSource = self
        
        // if there is a value in current text field, try to find it existing list
        if let currentValue = textField.text {
            
            var row : Int?
            
            row = self.licenseTypes.index(of: currentValue)
            // we got it, let's set select it
            if row != nil {
                picker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        
        picker.backgroundColor = UIColor(netHex: 0x233549)
        textField.inputView = self.picker
        
        // toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(netHex: 0x233549)
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // done
    func doneClick() {
        //activeTF.text = activeValue
        activeTF.resignFirstResponder()
        
    }
    
    //MARK: AAVAnimator method.
    //DropDown View function
    func animateWithTransition(_ animator: AAViewAnimators) {
        self.dropDownVehicleView.aa_animate(duration: 1.5, springDamping: .slight, animation: animator) { inAnimating in
            
            if inAnimating {
                print("Animating ....")
            }
            else {
                print("Animation Done")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AccountViewController: UITextFieldDelegate {
    
    // start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // set active Text Field
        activeTF = textField
        
        self.pickUpValue(textField: textField)
        
    }
}


//MARK: simple picker delegate
extension AccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.licenseTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.licenseTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.licenseTypeTxt.text = self.licenseTypes[row]
    }
    
}

//MARK: SCDateFieldDelegate delegate method
extension AccountViewController: SCDateFieldDelegate {
    
    func dateTextHasChanged(_ dateString: String, date: Date) {
        if self.birthdayaa.isEditing || self.birthdaydd.isEditing || self.self.birthdaymm.isEditing {
            
            let format_year = DateFormatter()
            format_year.dateFormat = "yyyy"
            let year = format_year.string(from: date)
            self.birthdayaa.text = year
            
            //MARK: Making project name - month.
            let format_month = DateFormatter()
            format_month.dateFormat = "MM"
            let month = format_month.string(from: date)
            self.birthdaymm.text = month
            
            //MARK: Making project name - day.
            let format_day = DateFormatter()
            format_day.dateFormat = "dd"
            let day = format_day.string(from: date)
            self.birthdaydd.text = day
        }else if self.creditaa.isEditing || self.creditmm.isEditing || self.creditdd.isEditing {
            let format_year = DateFormatter()
            format_year.dateFormat = "yyyy"
            let year = format_year.string(from: date)
            self.creditaa.text = year
            
            //MARK: Making project name - month.
            let format_month = DateFormatter()
            format_month.dateFormat = "MM"
            let month = format_month.string(from: date)
            self.creditmm.text = month
            
            //MARK: Making project name - day.
            let format_day = DateFormatter()
            format_day.dateFormat = "dd"
            let day = format_day.string(from: date)
            self.creditdd.text = day
        }else if self.expirationaa.isEditing || self.expirationdd.isEditing || self.expirationmm.isEditing {
            let format_year = DateFormatter()
            format_year.dateFormat = "yyyy"
            let year = format_year.string(from: date)
            self.expirationaa.text = year
            
            //MARK: Making project name - month.
            let format_month = DateFormatter()
            format_month.dateFormat = "MM"
            let month = format_month.string(from: date)
            self.expirationmm.text = month
            
            //MARK: Making project name - day.
            let format_day = DateFormatter()
            format_day.dateFormat = "dd"
            let day = format_day.string(from: date)
            self.expirationdd.text = day
        }
    }
}

extension AccountViewController: PagedFlowViewDelegate, PagedFlowViewDataSource {
    
    //MARK: pagedFlowView Delegate
    func sizeForPage(in flowView: PagedFlowView!) -> CGSize {
        return CGSize(width: self.view.bounds.size.width/3, height: 80)
    }
    
    func flowView(_ flowView: PagedFlowView!, didScrollToPageAt index: Int) {
        print("Scrolled to page #\(index)")
    }
    func flowView(_ flowView: PagedFlowView!, didTapPageAt index: Int) {
        print("Tapped on page #\(index)")
        self.vehicleImage.image = UIImage(named: self.vehicleImages[index])
    }
    
    // MARK: PagedFlowView Datasource
    func numberOfPages(in flowView: PagedFlowView!) -> Int {
        return self.vehicleTypes.count
    }
    
    func flowView(_ flowView: PagedFlowView!, cellForPageAt index: Int) -> UIView! {
        
        var myView = flowView.dequeueReusableCell()
        //let Width = flowView.bounds.size.width
        
        myView = UIView()
        myView?.layer.masksToBounds = true
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        image.image = UIImage(named: self.vehicleImages[index])
        myView?.addSubview(image)
        
        let vehicleName = UILabel(frame: CGRect(x: 10, y: 60, width: 55, height: 20))
        vehicleName.text = self.vehicleTypes[index]
        vehicleName.textAlignment = .center
        vehicleName.textColor = UIColor.white
        vehicleName.font = UIFont.systemFont(ofSize: 15, weight: 0.8)
        myView?.addSubview(vehicleName)
        
        return myView
        
    }
    
}

extension AccountViewController: CountrySelectedDelegate {
    
    func SRcountrySelected(countrySelected country: Country, flagImage: UIImage) {
        self.selectedCountry = country
        print("country selected  code \(self.selectedCountry.country_code), country name \(self.selectedCountry.country_name), dial code \(self.selectedCountry.dial_code)")
        self.countryCode.text =  "\(self.selectedCountry.dial_code)"
        self.flagImage.image = flagImage
        
    }
    
}
