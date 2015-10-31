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

let kPrefixTitle = "Title:\t"
let kPrefixCategory = "Category:\t"
let kPrefixStart = "Start Time:\t"
let kPrefixEnd  = "End Time:\t"
let kPrefixAttendees = "Attendees:\t"
let kPrefixDescription = "Description:\t"


class AddEventDetailsViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
   /* @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var numExplorersText: UITextField!
    @IBOutlet weak var startTimeText: UITextField!
    @IBOutlet weak var endTimeText: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var explorersText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!*/
    
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
        mapView.delegate = self
        self.startTimeText.tag = kDateTextOne
        self.endTimeText.tag = kDateTextTwo
        self.numExplorersText.tag = kTextThree
        self.categoryText.tag = kTextFour
        
        initTextFields()
        
        
        
        //$$$ change to read location coords from event class var
        coords = CLLocationCoordinate2DMake(37.8025,-122.406)
        print("Coords = \(coords.latitude)")
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.coords.latitude, longitude: self.coords.longitude), zoomLevel: 15, animated: true)
        
        //$$$ change to read the event location string from event class var
        self.updateLocationInLabel("1, Telegraph Hill, San Francisco, CA 94133")
        
        titleText.becomeFirstResponder()
        createButton.backgroundColor = UIColor.orangeColor()
        
    }
    
    func initTextFields() {
        let currdate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        let strDate = dateFormatter.stringFromDate(currdate)
        startTimeText.text = "Start Time:\t\(strDate)"
        endTimeText.text = "End Time:\t\(strDate)"
        //Add an hour to current date here
        titleText.text = kPrefixTitle
        numExplorersText.text = kPrefixAttendees + "1"
        categoryText.text = kPrefixCategory + "None"
        descriptionText.text = kPrefixDescription
        
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
        let title = titleText.text
        newEvent.eventTitle = title!.substringWithRange(Range<String.Index>(start: title!.startIndex.advancedBy(kPrefixTitle.characters.count), end: title!.endIndex.advancedBy(0)))
        
        
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
        
        
        event = newEvent
        
        event.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object has been saved.")
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                // There was a problem, check error.description
            }
        }

    }
    
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
        //datePickerView.backgroundColor = UIColor.greenColor()
        //datePickerView.layer.borderWidth = 4
        
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
            categoryText.text = kPrefixCategory + "None"
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
        
        let largeFont = UIFont(name: "Arial", size: 14.0)!
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
