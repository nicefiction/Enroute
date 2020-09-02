//
//  Flight.swift
//  Enroute
//
//  Created by Olivier Van hamme on 02/09/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation
import CoreData
import Combine



extension Flight { // should probably be Identifiable & Comparable
    
    @discardableResult
    
    
     // //////////////
    //  MARK: METHODS
    
    static func update(from faflight: FAFlight ,
                       in context: NSManagedObjectContext)
        -> Flight {
            
        let request = fetchRequest(NSPredicate(format: "ident_ = %@", faflight.ident))
        let results = (try? context.fetch(request)) ?? []
        let flight = results.first ?? Flight(context: context)
        flight.ident = faflight.ident
        flight.origin = Airport.withICAO(faflight.origin, context: context)
        flight.destination = Airport.withICAO(faflight.destination, context: context)
        flight.arrival = faflight.arrival
        flight.departure = faflight.departure
        flight.filed = faflight.filed
        flight.aircraft = faflight.aircraft
        flight.airline = Airline.withCode(faflight.airlineCode, in: context)
        flight.objectWillChange.send()
        // might want to save() here
        // Flights are currently only loaded from Airport.fetchIncomingFlights()
        // which saves
        // but it might be nice if this method could stand on its own and save itself
            
        return flight
    } // static func update(from , in) -> Flight {
    
    
    static func fetchRequest(_ predicate: NSPredicate)
        -> NSFetchRequest<Flight> {
            
        let request = NSFetchRequest<Flight>(entityName: "Flight")
        request.sortDescriptors = [NSSortDescriptor(key: "arrival_", ascending: true)]
        request.predicate = predicate
            
        return request
    } // static func fetchRequest(_ predicate) -> NSFetchRequest<Flight> {}
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var arrival: Date {
        get { arrival_CoreData ?? Date(timeIntervalSinceReferenceDate: 0) }
        set { arrival_CoreData = newValue }
    }
    
    
    var ident: String {
        get { ident_CoreData ?? "Unknown" }
        set { ident_CoreData = newValue }
    }
    
    
    var destination: Airport {
        get { destination_CoreData! } // TODO: protect against nil before shipping?
        set { destination_CoreData = newValue }
    }
    
    
    var origin: Airport {
        get { origin_CoreData! } // TODO: maybe protect against when app ships?
        set { origin_CoreData = newValue }
    }
    
    
    var airline: Airline {
        get { airline_CoreData! } // TODO: maybe protect against when app ships?
        set { airline_CoreData = newValue }
    }
    
    
    var number: Int {
        Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0
    }
    
    
    
    
} // extension Flight {}
