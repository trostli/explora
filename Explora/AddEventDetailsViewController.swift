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

class AddEventDetailsViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var numExplorersText: UITextField!
    @IBOutlet weak var startTimeText: UITextField!
    @IBOutlet weak var endTimeText: UITextField!
    var coords : CLLocationCoordinate2D!
    private var explorers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    
    @IBAction func endTimeEdit(sender: UITextField) {
        addDatePicker(sender)
    }
    
    @IBAction func explorersEdit(sender: UITextField) {
        let numberPicker  : UIPickerView = UIPickerView()
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneNumPickerPressed"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed"))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        
        toolBar.userInteractionEnabled = true
        self.numExplorersText.inputAccessoryView = toolBar
        
        sender.inputView = numberPicker
        
    }
    
    @IBAction func timeEdit(sender: UITextField) {
        //addDatePicker(sender)
        
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
        if sender.tag == 1 {
            doneButton.tag = 1
        } else {
            if sender.tag == 2 {
                doneButton.tag = 2
            }
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPressed"))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        
        toolBar.userInteractionEnabled = true
        //self.startTimeText.inputAccessoryView = toolBar
        sender.inputAccessoryView = toolBar
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)

        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(sender.date)
        print(strDate)
        self.startTimeText.text = strDate
    }
    
    func donePressed(sender: UIBarButtonItem) {
        //self.timeText.inputView?.removeFromSuperview()
        //self.timeText.inputAccessoryView?.removeFromSuperview()
        //self.startTimeText.resignFirstResponder()
        if sender.tag == 1 {
            self.startTimeText.resignFirstResponder()
        }
        if sender.tag == 2 {
            self.endTimeText.resignFirstResponder()
        }
    }
    
    func cancelPressed() {
        
    }
    
    func doneNumPickerPressed () {
        self.numExplorersText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.startTimeText.tag = 1
        self.endTimeText.tag = 2
        print("Coords = \(coords.latitude)")
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.coords.latitude, longitude: self.coords.longitude), zoomLevel: 15, animated: true)
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
        return explorers.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return explorers[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        numExplorersText.text = explorers[row]
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
