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
        PFUser.logOut()
        generateUser1AndEvent()
        generateUser2AndEvent()
        generateUser3AndEvent()
        generateUser4AndEvent()
        generateUser5AndEvent()
    }
    
    // Montgomery
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
        event1.attendeesLimit = 8;
        let participateRelation1 = event1.attendees
        participateRelation1!.addObject(event1.createdBy!)
        
        // @37.80266,-122.4079787
        event1.eventLocation = PFGeoPoint(latitude: 37.80266, longitude: -122.4079787);
        event1.eventTitle = "Coit Tower!"
        event1.eventDescription = "Let's get some exercise and climb all the way to the top of Coit Tower."
        event1.eventAddress = "1 Telegraph Hill Blvd\nSan Francisco, CA 94133"
        
        // meeting location
        // @37.7955277,-122.3956398
        event1.meetingLocationLat = 37.7955277
        event1.meetingLocationLng = -122.3956398
        event1.meetingAddress = "Ferry Building Marketplace\nSan Francisco, CA"
        
        // meeting time
        event1.meetingStartTime = NSDate(timeIntervalSinceNow: 300000)
        event1.meetingEndTime = NSDate(timeIntervalSinceNow: 303600)
        
        // category
        event1.category = ExploraEventCategory.Travel.rawValue
        
        try! event1.save()
        print("event1 saved?")
        PFUser.logOut()
    }
    
    // Little Italy
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
        // @37.7894069,-122.403256
        event2.meetingLocationLat = 37.7894069
        event2.meetingLocationLng = -122.403256
        event2.meetingAddress = "Montgomery St. BART Station\nSan Francisco, CA"
        
        // meeting time
        event2.meetingStartTime = NSDate(timeIntervalSinceNow: 400000)
        event2.meetingEndTime = NSDate(timeIntervalSinceNow: 403600)
        
        // category
        event2.category = ExploraEventCategory.FoodDrink.rawValue
        
        try! event2.save()
        print("event2 saved?")
        PFUser.logOut()
    }
    
    // Yosemite
    class func generateUser3AndEvent() {
        let user3 = PFUser()
        user3.username = "Linda333"
        user3.password = "testing"
        user3.email = "linda333@testing.com"
        
        try! user3.signUp()
        
        let event3 = ExploraEvent()
        event3.createdBy = user3
        
        // Attendees
        event3.attendeesLimit = 5;
        let participateRelation3 = event3.attendees
        participateRelation3!.addObject(user3)
        
        // @37.729092,-119.5363824
        event3.eventLocation = PFGeoPoint(latitude: 37.729092, longitude: -119.5363824);
        event3.eventTitle = "Hiking!"
        event3.eventDescription = "Let's hike up the John Muir Trail!"
        event3.eventAddress = "Liberty Cap\nMariposa County, CA"
        
        // meeting location
        // @37.8741697,-122.2708621
        event3.meetingLocationLat = 37.8741697
        event3.meetingLocationLng = -122.2708621
        event3.meetingAddress = "1860 Shattuck Ave\nBerkeley, CA 94704"
        
        // meeting time
        event3.meetingStartTime = NSDate(timeIntervalSinceNow: 300000)
        event3.meetingEndTime = NSDate(timeIntervalSinceNow: 303600)
        
        // category
        event3.category = ExploraEventCategory.Travel.rawValue
        
        try! event3.save()
        print("event3 saved?")
        PFUser.logOut()
    }
    
    // Twitter
    class func generateUser4AndEvent() {
        let user4 = PFUser()
        user4.username = "Sarah333"
        user4.password = "testing"
        user4.email = "sarah333@testing.com"
        
        try! user4.signUp()
        
        let event4 = ExploraEvent()
        event4.createdBy = user4
        
        // Attendees
        event4.attendeesLimit = 30;
        let participateRelation3 = event4.attendees
        participateRelation3!.addObject(user4)
        
        // @37.776692,-122.4189706
        event4.eventLocation = PFGeoPoint(latitude: 37.776692, longitude: -122.4189706);
        event4.eventTitle = "Tour of Twitter!"
        event4.eventDescription = "Check out the Twitter HQ!"
        event4.eventAddress = "1355 Market St #900\nSan Francisco, CA 94103"
        
        // meeting location
        // @37.776692,-122.4189706
        event4.meetingLocationLat = 37.776692
        event4.meetingLocationLng = -122.4189706
        event4.meetingAddress = "1355 Market St #900\nSan Francisco, CA 94103"
        
        // meeting time
        event4.meetingStartTime = NSDate(timeIntervalSinceNow: 500000)
        event4.meetingEndTime = NSDate(timeIntervalSinceNow: 503600)
        
        // category
        event4.category = ExploraEventCategory.CommunityCulture.rawValue
        
        try! event4.save()
        print("event4 saved?")
        PFUser.logOut()
    }
    
    // Codepath
    class func generateUser5AndEvent() {
        let user5 = PFUser()
        user5.username = "Jim433"
        user5.password = "testing"
        user5.email = "jim433@testing.com"
        
        try! user5.signUp()
        
        let event5 = ExploraEvent()
        event5.createdBy = user5
        
        // Attendees
        event5.attendeesLimit = 10;
        let participateRelation3 = event5.attendees
        participateRelation3!.addObject(user5)
        
        // @37.7708021,-122.4060909
        event5.eventLocation = PFGeoPoint(latitude: 37.7708021, longitude: -122.4060909);
        event5.eventTitle = "Codepath iOS"
        event5.eventDescription = "Learn iOS with Ben"
        event5.eventAddress = "699 8th St\nSan Francisco, CA 94103"
        
        // meeting location
        // @37.7708021,-122.4060909
        event5.meetingLocationLat = 37.7708021
        event5.meetingLocationLng = -122.4060909
        event5.meetingAddress = "699 8th St\nSan Francisco, CA 94103"
        
        // meeting time
        event5.meetingStartTime = NSDate(timeIntervalSinceNow: 300000)
        event5.meetingEndTime = NSDate(timeIntervalSinceNow: 303600)
        
        // category
        event5.category = ExploraEventCategory.FamilyEducation.rawValue
        
        try! event5.save()
        PFUser.logOut()
        print("event5 saved?")
    }
}

