//
//  FlightSearch.swift
//  Enroute
//
//  Created by Olivier Van hamme on 27/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation
import CoreData


struct FlightSearch {
    
//    var destination: String
//    var origin: String?
//    var airline: String?
//    var inTheAir: Bool = true
    
    var destination: Airport
    var origin: Airport?
    var airline: Airline?
    var inTheAir: Bool = true
    
} // struct FlightSearch {}





extension FlightSearch {
    
    var predicate: NSPredicate {
        var format = "destination_CoreData = %@"
        var args: [NSManagedObject] = [destination] // args could be [Any] if needed
        
        if origin != nil {
            format += " and origin_CoreData = %@"
            args.append(origin!)
        }
        
        if airline != nil {
            format += " and airline_CoreData = %@"
            args.append(airline!)
        }
        
        if inTheAir { format += " and departure != nil" }
        
        return NSPredicate(format: format, argumentArray: args)
    } // var predicate: NSPredicate {}
    
} // extension FlightSearch {}
