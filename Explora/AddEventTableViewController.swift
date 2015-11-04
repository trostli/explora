//
//  AddEventTableViewController.swift
//  Explora
//
//  Created by Sudipta Bhowmik on 11/3/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox
import MapKit




class AddEventTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let kPickerOne  = 1
    let kPickerTwo = 2
    let kDateTextOne = 1
    let kDateTextTwo = 2
    let kTextThree = 3
    let kTextFour = 4

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeText: UITextField!
    @IBOutlet weak var endTimeText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var numExplorersText: UITextField!
    private var coords : CLLocationCoordinate2D!
    //Move this to ExploraEvent model
    private var explorers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var event = ExploraEvent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //coords = CLLocationCoordinate2DMake(37.8025,-122.406)
        coords = event.eventCoordinate
        
        loadMap(coords)
        
        //addressLabel.text = "1, Telegraph Hill, San Francisco, CA"
        addressLabel.text = event.eventAddress!
        
        //Hide extra cells at bottom of tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Add Tap guesture
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Add tags to distinguish the uipickers
        self.startTimeText.tag = kDateTextOne
        self.endTimeText.tag = kDateTextTwo
        self.numExplorersText.tag = kTextThree
        self.categoryText.tag = kTextFour
        
        if let font = UIFont(name: "Arial", size: 16) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
        }
        
        
        titleText.becomeFirstResponder()
                
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func loadMap(coords: CLLocationCoordinate2D) {
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
        
        // Declare the marker `hello`
        let hello = MGLPointAnnotation()
        hello.coordinate = coords
        
        // Add marker `hello` to the map
        mapView.addAnnotation(hello)
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.userInteractionEnabled = false
        
    }

    @IBAction func startTimeEdit(sender: UITextField) {
        addDatePicker(sender)
    }

    @IBAction func endTimeEdit(sender: UITextField) {
        addDatePicker(sender)
    }
    
    @IBAction func categoryEdit(sender: UITextField) {
        addPicker(sender)
    }
    
    @IBAction func attendeesEdit(sender: UITextField) {
        addPicker(sender)
    }
    
    func addDatePicker(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        let currentDate = NSDate()
        datePickerView.minimumDate = currentDate
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("donePressed:"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed:"))
        if let font = UIFont(name: "Arial", size: 15) {
            doneButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font], forState: UIControlState.Normal)
            cancelButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        
        toolBar.userInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        if sender.tag == kDateTextOne {
            doneButton.tag = kPickerOne
            datePickerView.tag = kPickerOne
            cancelButton.tag = kPickerOne
        } else {
            if sender.tag == kDateTextTwo {
                doneButton.tag = kPickerTwo
                datePickerView.tag = kPickerTwo
                cancelButton.tag = kPickerTwo
            }
        }
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle

        let strDate = dateFormatter.stringFromDate(sender.date)
        if sender.tag == kPickerOne {
            self.startTimeText.text = strDate
            event.meetingStartTime = (sender.date)
        } else if sender.tag == kPickerTwo {
            self.endTimeText.text = strDate
            event.meetingEndTime = (sender.date)
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

    func addPicker(sender: UITextField) {
        let pickerView  : UIPickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.clearColor()
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pickerDonePressed:"))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed:"))
        if let font = UIFont(name: "Arial", size: 15) {
            doneButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font], forState: UIControlState.Normal)
            cancelButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //tag the Picker & Button controls as per the sender textField's tag
        if (sender.tag == kTextThree) {
            pickerView.tag = kTextThree
            doneButton.tag = kTextThree
            cancelButton.tag = kTextThree
        } else if (sender.tag == kTextFour) {
            pickerView.tag = kTextFour
            doneButton.tag = kTextFour
            cancelButton.tag = kTextFour
        }
        
        sender.inputAccessoryView = toolBar
        sender.inputView = pickerView
        
    }

    func pickerDonePressed (sender: UIBarButtonItem) {
        if sender.tag == kTextThree {
            self.numExplorersText.resignFirstResponder()
        } else if sender.tag == kTextFour {
            self.categoryText.resignFirstResponder()
        }
    }
    
    func cancelPressed (sender: UIBarButtonItem) {
        if sender.tag == kPickerOne {
            self.startTimeText.resignFirstResponder()
        } else if sender.tag == kPickerTwo {
            self.endTimeText.resignFirstResponder()
        } else if sender.tag == kTextThree {
            self.numExplorersText.resignFirstResponder()
        } else if sender.tag == kTextFour {
            self.categoryText.resignFirstResponder()
        }
    }
    
    @IBAction func cancelAddEvent(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addEvent(sender: UIBarButtonItem) {
        event.eventTitle = titleText.text

        let attendeesLimit:Int? = Int(numExplorersText.text!)
        event.attendeesLimit = attendeesLimit
        
        let description = descriptionText.text
        
        event.eventDescription = description
        event.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object has been saved.")
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                print("Error : \(error!.description)")
            }
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
            //categoryText.text = kDefaultCategory
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
            numExplorersText.text = explorers[row]
            event.attendeesLimit = row
        } else if pickerView.tag == kTextFour {
            let cat = ExploraEventCategories.categories[row]
            for(_,val) in cat {
                categoryText.text = val
                event.category = row
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else {
            return 6
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
