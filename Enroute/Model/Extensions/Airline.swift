//
//  Airline.swift
//  Enroute
//
//  Created by Olivier Van hamme on 02/09/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation
import CoreData
import Combine


extension Airline: Identifiable ,
                   Comparable {
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var code: String {
        get { code_CoreData! } // TODO: maybe protect against when app ships?
        set { code_CoreData = newValue }
    }
    
    
    var name: String {
        get { name_CoreData ?? code }
        set { name_CoreData = newValue }
    }
    
    
    var shortname: String {
        get { (shortname_CoreData ?? "").isEmpty ? name : shortname_CoreData! }
        set { shortname_CoreData = newValue }
    }
    
    
    var flights: Set<Flight> {
        get { (flights_CoreData as? Set<Flight>) ?? [] }
        set { flights_CoreData = newValue as NSSet }
    } // var flights: Set<Flight> {}
    
    
    var friendlyName: String { shortname.isEmpty ? name : shortname }
    
    
    public var id: String { code }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    static func withCode(_ code: String ,
                         in context: NSManagedObjectContext)
        -> Airline {
            
        let request = fetchRequest(NSPredicate(format: "code_CoreData = %@", code))
        let results = (try? context.fetch(request)) ?? []
            
        if
            let airline = results.first {
            return airline
        } else {
            let airline = Airline(context: context)
            airline.code = code
            AirlineInfoRequest.fetch(code) { info in
                let airline = self.withCode(code, in: context)
                airline.name = info.name
                airline.shortname = info.shortname
                airline.objectWillChange.send()
                airline.flights.forEach { $0.objectWillChange.send() }
                try? context.save()
            } // AirlineInfoRequest.fetch(code) { info in }
            return airline
        } // if {} else {}
    } // static func withCode(_ , in) -> Airline {}

    
    static func fetchRequest(_ predicate: NSPredicate)
        -> NSFetchRequest<Airline> {
            
        let request = NSFetchRequest<Airline>(entityName : "Airline")
        request.sortDescriptors = [NSSortDescriptor(key : "name_CoreData" ,
                                                    ascending : true)]
        request.predicate = predicate
            
        return request
    } // static func fetchRequest(_:) -> NSFetchRequest<Airline> {}
    
    
    public static func < (lhs: Airline ,
                          rhs: Airline)
        -> Bool {
            
        lhs.name < rhs.name
    } // public static func < (lhs: , rhs:) -> Bool {}
    
    
    
    
} // extension Airline {}
