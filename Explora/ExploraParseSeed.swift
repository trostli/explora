//
//  ExploraParseSeed.swift
//  Explora
//
//  Created by admin on 11/1/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Parse

class ExploraParseSeed {
    
    //        var createdBy: PFUser?
    //        var attendees: PFRelation?
    //        var attendeesLimit: Int?
    //        var eventTitle: String?
    //        var eventDescription: String?
    //        var eventLocation: PFGeoPoint?
    //        var eventAddress: String?
    //        var meetingLocationLat: CLLocationDegrees?
    //        var meetingLocationLng: CLLocationDegrees?
    //        var meetingStartTime: NSDate?
    //        var meetingEndTime: NSDate?
    //        var category: Int?
    
    class func seedDatabase() {
        
//        generateUser1AndEvent()
    }
    
    class func generateUser1AndEvent() {
        // Create users
        let user1 = PFUser()
        user1.username = "mark123"
        user1.password = "testing"
        user1.email = "mark123@test.com"
        
        try! user1.signUp()
        
        // Create events
        
        let event1 = ExploraEvent()
        event1.createdBy = PFUser.currentUser()
        
        // Attendees
        event1.attendeesLimit = 5;
        let participateRelation1 = event1.attendees
        participateRelation1!.addObject(event1.createdBy!)
        
        // @37.80266,-122.4079787
        event1.eventLocation = PFGeoPoint(latitude: 37.80266, longitude: -122.4079787);
        event1.eventTitle = "Coit Tower!"
        event1.eventDescription = "Let's get some exercise and climb all the way to the top of Coit Tower."
        event1.eventAddress = "Coit Tower\nSan Francisco, CA 94133"
        
        // meeting location
        // @37.7955277,-122.3956398
        event1.meetingLocationLat = 37.7955277
        event1.meetingLocationLng = -122.3956398
        event1.meetingAddress = "Ferry Building Marketplace\nSan Francisco, CA"
        
        // meeting time
        event1.meetingStartTime = NSDate(timeIntervalSinceNow: 10000)
        event1.meetingStartTime = NSDate(timeIntervalSinceNow: 13600)
        
        // category
        event1.category = ExploraEventCategory.Travel.rawValue
        
        try! event1.save()
        print("event1 saved?")
        PFUser.logOut()
        generateUser2AndEvent()
    }
    
    class func generateUser2AndEvent() {
        let user2 = PFUser()
        user2.username = "lisa345"
        user2.password = "testing"
        user2.email = "lisa345@testing.com"
        
        try! user2.signUp()
        
        let event2 = ExploraEvent()
        event2.createdBy = user2
        
        // Attendees
        event2.attendeesLimit = -1;
        let participateRelation2 = event2.attendees
        participateRelation2!.addObject(user2)
        
        // @37.8007601,37.8007601
        event2.eventLocation = PFGeoPoint(latitude: 37.8007601, longitude: 37.8007601);
        event2.eventTitle = "Party startin'"
        event2.eventDescription = "Bar hopping around Little Italy"
        event2.eventAddress = "Little Italy\nSan Francisco, CA 94133"
        
        // meeting location
        // @37.7894069,-122.403256,17
        event2.meetingLocationLat = 37.7894069
        event2.meetingLocationLng = -122.403256
        event2.meetingAddress = "Montgomery St. BART Station\nSan Francisco, CA"
        
        // meeting time
        event2.meetingStartTime = NSDate(timeIntervalSinceNow: 20000)
        event2.meetingStartTime = NSDate(timeIntervalSinceNow: 23600)
        
        // category
        event2.category = ExploraEventCategory.FoodDrink.rawValue
        
        try! event2.save()
        print("event2 saved?")
        PFUser.logOut()
        generateUser3AndEvent()
    }
    
    class func generateUser3AndEvent() {
        let user3 = PFUser()
        user3.username = "Linda333"
        user3.password = "testing"
        user3.email = "linda333@testing.com"
        
        try! user3.signUp()
        
        let event3 = ExploraEvent()
        event3.createdBy = user3
        
        // Attendees
        event3.attendeesLimit = -1;
        let participateRelation3 = event3.attendees
        participateRelation3!.addObject(user3)
        
        // @37.8007601,37.8007601
        event3.eventLocation = PFGeoPoint(latitude: 37.8007601, longitude: 37.8007601);
        event3.eventTitle = "Party startin'"
        event3.eventDescription = "Bar hopping around Little Italy"
        event3.eventAddress = "Little Italy\nSan Francisco, CA 94133"
        
        // meeting location
        // @37.7894069,-122.403256,17
        event3.meetingLocationLat = 37.7894069
        event3.meetingLocationLng = -122.403256
        event3.meetingAddress = "Montgomery St. BART Station\nSan Francisco, CA"
        
        // meeting time
        event3.meetingStartTime = NSDate(timeIntervalSinceNow: 20000)
        event3.meetingStartTime = NSDate(timeIntervalSinceNow: 23600)
        
        // category
        event3.category = ExploraEventCategory.FoodDrink.rawValue
        
        try! event3.save()
        print("event3 saved?")
    }
}

