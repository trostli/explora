//
//  AddEventDetailsViewController.swift
//  Explora
//
//  Created by Sudipta Bhowmik on 10/22/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import MapKit
import Mapbox
import Parse


let kPickerOne  = 1
let kPickerTwo = 2
let kDateTextOne = 1
let kDateTextTwo = 2
let kTextThree = 3
let kTextFour = 4

let kPrefixTitle = "Title"
let kPrefixCategory = "Category\t"
let kPrefixStart = "Start Time\t"
let kPrefixEnd  = "End Time\t"
let kPrefixAttendees = "Attendees\t"
let kPrefixDescription = "Description"
let kDefaultCategory = "Other"
let kDefaultAttendees = "2"


class AddEventDetailsViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var startTimeText: UITextField!
    
    @IBOutlet weak var endTimeText: UITextField!
    
    @IBOutlet weak var numExplorersText: UITextField!
    
    @IBOutlet weak var categoryText: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var createButton: UIButton!
    
    var coords : CLLocationCoordinate2D!
    
    //Move this to ExploraEvent model
    private var explorers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var event = ExploraEvent()
    private var newEvent = ExploraEvent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //$$$ change to read location coords from event class var
        //coords = event.eventCoordinate
        coords = CLLocationCoordinate2DMake(37.8025,-122.406)
        print("Coords = \(coords.latitude)")

        
        mapView.delegate = self
        // available styles:
        //   streets-v8.json
        //   emerald-v8.json
        //   light-v8.json
        //   dark-v8.json
        //   satellite-v8.json
        mapView.styleURL = NSURL(string: "asset://styles/emerald-v8.json");
        
        self.mapView.setCenterCoordinate(coords, zoomLevel: 15, direction: 180, animated: false)
        let camera = MGLMapCamera(lookingAtCenterCoordinate: coords, fromDistance: 9000, pitch: 45, heading: 0)
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle
        let hello = MGLPointAnnotation()
        hello.coordinate = coords
        hello.title = "Hello world!"
        // Add marker `hello` to the map
        mapView.addAnnotation(hello)
        
        
        self.startTimeText.tag = kDateTextOne
        self.endTimeText.tag = kDateTextTwo
        self.numExplorersText.tag = kTextThree
        self.categoryText.tag = kTextFour
        
    
        self.titleText.alpha = 0.8
        self.startTimeText.alpha = 0.8
        self.endTimeText.alpha = 0.8
        self.categoryText.alpha = 0.8
        self.numExplorersText.alpha = 0.8
        self.createButton.alpha = 0.8
        self.descriptionText.backgroundColor = UIColor.whiteColor()
        self.descriptionText.alpha = 0.8
        self.descriptionText.layer.cornerRadius = 5
        
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        initTextFields()
        initEvent()
        
        //ADD TAP GESTURE

        
        //$$$ change to read the event location string from event class var
        //self.updateLocationInLabel(event.eventAddress)
        self.updateLocationInLabel("1, Telegraph Hill, San Francisco, CA 94133")
        
        titleText.becomeFirstResponder()
        createButton.backgroundColor = UIColor.orangeColor()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        if titleText.isFirstResponder() {
            titleText.resignFirstResponder()
        } else {
            descriptionText.resignFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("textField text \(textField.text)")
        if textField == titleText && textField.text == kPrefixTitle
        {
            // move cursor to start
            moveCursorToStart(textField)
        }
        print("shouldbegin")
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.characters.count)! - range.length
        print("newlength: \(newLength)")
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            if textField == titleText && textField.text == kPrefixTitle
            {
                print("clearing text")
                textField.text = ""
                
            } else {
                textField.textColor = UIColor.blackColor()
            }
        }
        return true
    }
    
    func moveCursorToStart(textField: UITextField)
    {
        let beginning = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(beginning, toPosition:beginning)
        print("beginning \(beginning)")
        //dispatch_async(dispatch_get_main_queue(), {
        //    let beginning = textField.beginningOfDocument
         //   textField.selectedTextRange = textField.textRangeFromPosition(beginning, toPosition: beginning)
       // })
    }
    
    
    /*func keyboardWillShow(notification : NSNotification) {
        if descriptionText.isFirstResponder() {
            var rect = self.view.frame;
            
            rect.origin.y -= 80
            rect.size.height += 80
            self.view.frame = rect
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if descriptionText.isFirstResponder() {
            var rect = self.view.frame;
            
            rect.origin.y += 80
            rect.size.height -= 80
            self.view.frame = rect
        }

    }*/
    
    func initTextFields() {
        let currdate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let strDate = dateFormatter.stringFromDate(currdate)
        startTimeText.text = "Start Time:\t\(strDate)"
        
        
        //Add an hour to current date here
        endTimeText.text = "End Time:\t\(strDate)"
        
        
        titleText.placeholder = kPrefixTitle
        titleText.delegate = self
        titleText.textColor = UIColor.lightGrayColor()

        numExplorersText.text = kPrefixAttendees + kDefaultAttendees
        categoryText.text = kPrefixCategory + kDefaultCategory
        descriptionText.text = kPrefixDescription
        descriptionText.textColor = UIColor.lightGrayColor()
        
        
        
    }
    
    func initEvent() {
        //Set default values for the event
        let currdate = NSDate()
        newEvent.eventTitle = ""
        newEvent.meetingStartTime = currdate
        
        //Add 2 hours for end Time
        newEvent.meetingEndTime = currdate
        newEvent.category = ExploraEventCategory.CommunityCulture.rawValue
        newEvent.attendeesLimit = 2
        newEvent.eventDescription = ""
        //newEvent.creatorID = event.creatorID
        //newEvent.eventLocation = event.eventLocation
    }
    
    @IBAction func endTimeEdit(sender: UITextField) {
        addDatePicker(sender)
    }
   
    @IBAction func explorersEdit(sender: UITextField) {
        addPicker(sender)
    }
  
    @IBAction func startTimeEdit(sender: UITextField) {
        addDatePicker(sender)
    
    }
 
    @IBAction func categoriesEdit(sender: UITextField) {
        addPicker(sender)
    }
    
    
    @IBAction func createPressed(sender: UIButton) {
        //self.event.eventLocation = geoPoint
        newEvent.eventTitle = titleText.text
        
        //newEvent.eventTitle = title!.substringWithRange(Range<String.Index>(start: title!.startIndex.advancedBy(kPrefixTitle.characters.count), end: title!.endIndex.advancedBy(0)))
        
        
        let desc = descriptionText.text
        newEvent.eventDescription = desc!.substringWithRange(Range<String.Index>(start: desc!.startIndex.advancedBy(kPrefixDescription.characters.count), end: desc!.endIndex.advancedBy(0)))
        
        //Set the creator ID & event location from passed in event Object
        //newEvent.creatorID = event.creatorID
        //newEvent.eventLocation = event.eventLocation
        
        print(".eventTitle \(newEvent.eventTitle)")
        print(".eventDescription \(newEvent.eventDescription)")
        print(".attendees \(newEvent.attendeesLimit)")
        print(".startTime \(newEvent.meetingStartTime)")
        print(".endTime \(newEvent.meetingEndTime)")
        print(".category \(newEvent.category)")
        
        
        /*event = newEvent
        
        event.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object has been saved.")
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                // There was a problem, check error.description
            }
        }*/

    }
    
  /*  func textFieldDidBeginEditing(textField: UITextField) {
        let beginning = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(beginning, toPosition: beginning)
        textField.placeholder = nil
        print("didbegin")
    }*/
    
    /*func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = "Title:"
        print("didend")
    }*/
    
    
    
    func addPicker(sender: UITextField) {
        let pickerView  : UIPickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pickerDonePressed:"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed"))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //tag the Picker & Button controls as per the sender textField's tag
        if (sender.tag == kTextThree) {
            pickerView.tag = kTextThree
            doneButton.tag = kTextThree
        } else if (sender.tag == kTextFour) {
            pickerView.tag = kTextFour
            doneButton.tag = kTextFour
        }
        
        sender.inputAccessoryView = toolBar
        sender.inputView = pickerView
        
    }
    
    
    func addDatePicker(sender: UITextField) {
        print("sender \(sender.text)")
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        let currentDate = NSDate()
        datePickerView.minimumDate = currentDate
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("donePressed:"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed"))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        
        toolBar.userInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        if sender.tag == kDateTextOne {
            doneButton.tag = kPickerOne
            datePickerView.tag = kPickerOne
        } else {
            if sender.tag == kDateTextTwo {
                doneButton.tag = kPickerTwo
                datePickerView.tag = kPickerTwo
            }
        }
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(sender.date)
        print(strDate)
        if sender.tag == kPickerOne {
            self.startTimeText.text = kPrefixStart + strDate
            newEvent.meetingStartTime = (sender.date)
        } else if sender.tag == kPickerTwo {
            self.endTimeText.text = kPrefixEnd + strDate
            newEvent.meetingEndTime = (sender.date)
        }
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        if sender.tag == 1 {
            self.startTimeText.resignFirstResponder()
        }
        if sender.tag == 2 {
            self.endTimeText.resignFirstResponder()
        }
    }
    
    func cancelPressed() {
        
    }
    
    func pickerDonePressed (sender: UIBarButtonItem) {
        if sender.tag == kTextThree {
            self.numExplorersText.resignFirstResponder()
        } else if sender.tag == kTextFour {
            self.categoryText.resignFirstResponder()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var count = 0
        if pickerView.tag == kTextThree {
            count = explorers.count
        } else if pickerView.tag == kTextFour {
            count = ExploraEventCategories.categories.count
        }
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        if (pickerView.tag == kTextThree) {
            title = explorers[row]
        } else if pickerView.tag == kTextFour {
            categoryText.text = kPrefixCategory + kDefaultCategory
            let cat = ExploraEventCategories.categories[row]
            //let a = cat[ExploraEventCategory.HealthWellness]
            for(_,val) in cat {
                title = val
            }
        }
        return(title)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == kTextThree {
            numExplorersText.text = kPrefixAttendees + explorers[row]
            newEvent.attendeesLimit = row
        } else if pickerView.tag == kTextFour {
            let cat = ExploraEventCategories.categories[row]
            for(_,val) in cat {
                categoryText.text = kPrefixCategory + val
                newEvent.category = row
            }
        }
        
    }
    
    
    //Move to api client
    func updateLocationInLabel(locationString: NSString) {
        let titleString = "Event Location"
        
        let textString = "\(titleString)\n\(locationString)"
        let attrText = NSMutableAttributedString(string: textString)
        
        let largeFont = UIFont(name: "Arial", size: 15.0)!
        let smallFont = UIFont(name: "Arial", size: 11.0)!
        
        //  Convert textString to NSString because attrText.addAttribute takes an NSRange.
        let titleTextRange = (textString as NSString).rangeOfString(titleString)
        let locationTextRange = (textString as NSString).rangeOfString(locationString as String)
        
        attrText.addAttribute(NSFontAttributeName, value: smallFont, range: titleTextRange)
        attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: titleTextRange)
        attrText.addAttribute(NSFontAttributeName, value: largeFont, range: locationTextRange)
        
        //print("attributed Text \(attrText)")
        addressLabel.numberOfLines = 0
        addressLabel.attributedText = attrText
        addressLabel.textAlignment = .Center
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
