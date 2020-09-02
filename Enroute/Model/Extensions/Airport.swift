//
//  Airport.swift
//  Enroute
//
//  Created by Olivier Van hamme on 02/09/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation
import CoreData
import Combine



extension Airport: Identifiable ,
                   Comparable {
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var flightsTo: Set<Flight> {
        get {
            (flightsTo_CoreData as? Set<Flight>) ?? []
        } // get {}
        
        set {
            flightsTo_CoreData = newValue as NSSet
        } // set {}
    } // var flightsTo: Set<Flight> {}
    
    
    var flightsFrom: Set<Flight> {
        get {
            (flightsFrom_CoreData as? Set<Flight>) ?? []
        } // get {}
        
        set {
            flightsFrom_CoreData = newValue as NSSet
        } // set {}
    } // var flightsTo: Set<Flight> {}
    
    
    var icao: String {
        get {
            // TODO: maybe protect against when app ships?
            icao_CoreData!
        } // get {}
        
        set {
            icao_CoreData = newValue
        } // set {}
    } // var icao: String {}

    
    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: self.name ?? "", location: self.location ?? "")
        
        return friendly.isEmpty ? icao : friendly
    } // var friendlyName: String {}

    
    public var id: String { icao }

    
    public static func < (lhs: Airport ,
                          rhs: Airport)
        -> Bool {
            
        lhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    } // public static func < (lhs: , rhs:) -> Bool {}
    
    
    
     // //////////////
    //  MARK: METHODS
    
    static func withICAO(_ icao: String ,
                         context: NSManagedObjectContext)
        -> Airport {
            /* STEP 1
             * Look up icao in Core Data :
             */
//            let request = NSFetchRequest<Airport>(entityName: "Airport")
//            request.predicate = NSPredicate(format : "icao_CoreData = %@" , icao)
//            request.sortDescriptors = [NSSortDescriptor(key : "location" , ascending : true)]
            let request = fetchRequest(NSPredicate(format: "icao_CoreData = %@" , icao))
            
            let airports = (try? context.fetch(request)) ?? []
            
            if
                let airport = airports.first {
                /* STEP 2
                 * If found , return it :
                 */
                return airport
            } else {
                /* STEP 3
                 * If not found , create one and fetch from FlightAware :
                 */
                let airport = Airport(context : context)
                airport.icao = icao
                
                AirportInfoRequest.fetch(icao) { airportInfo in
                    self.update(from : airportInfo , context : context)
                } // AirportInfoRequest.fetch(icao) { airportInfo in }
                
                return airport
            } // if let airport = airports.first {} else {}
    } // static func withICAO(_ icao: String) -> Airport {}
    
    
    static func update(from info: AirportInfo ,
                       context: NSManagedObjectContext) {
        
        if
            let icao = info.icao {
            let airport = self.withICAO(icao ,
                                        context : context)
            
            airport.latitude = info.latitude
            airport.longitude = info.longitude
            airport.name = info.name
            airport.location = info.location
            airport.timezone = info.timezone
            
            airport.objectWillChange.send()
            airport.flightsTo.forEach { $0.objectWillChange.send() }
            airport.flightsFrom.forEach { $0.objectWillChange.send() }
            
            
            try? context.save()
        } // if let icao = info.icao {}
    } // static func update(from , context) {}
    
    
    static func fetchRequest(_ predicate: NSPredicate)
        -> NSFetchRequest<Airport> {
            
           let request = NSFetchRequest<Airport>(entityName : "Airport")
           request.sortDescriptors = [NSSortDescriptor(key : "location" ,
                                                       ascending : true)]
           request.predicate = predicate
            
           return request
       } // static func fetchRequest(_:) -> NSFetchRequest<Airport> {}
    
    
    
} // extension Airport {}
