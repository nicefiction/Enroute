//
//  FlightList.swift
//  Enroute
//
//  Created by Olivier Van hamme on 27/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI
import CoreData


struct FlightList: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
//    @ObservedObject var flightFetcher: FlightFetcher
    @FetchRequest var flights: FetchedResults<Flight>
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS

    init(_ flightSearch: FlightSearch) {
        
//        self.flightFetcher = FlightFetcher(flightSearch: flightSearch)
//        let request = NSFetchRequest<Flight>(entityName: "Flight")
//        request.predicate = NSPredicate(format : "destination_CoreData = %@" , flightSearch.destination)
//        request.sortDescriptors = [NSSortDescriptor(key : "arrival_CoreData" , ascending : true)]
//        let request  = Flight.fetchRequest(NSPredicate(format: "destination_CoreData = %@" , flightSearch.destination))
        let request = Flight.fetchRequest(flightSearch.predicate)
        
        _flights = FetchRequest(fetchRequest : request)
    } // init() {}

    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
//    var flights: [FAFlight] { flightFetcher.latest }
    
    var body: some View {
        List {
            ForEach(flights, id: \.ident) { flight in
                FlightListEntry(flight: flight)
            }
        }
        .navigationBarTitle(title)
    } // var body: some View {}
    
    
    private var title: String {
        let title = "Flights"
        if
            let destination = flights.first?.destination.icao {
            
            return title + " to \(destination)"
        } else {
            return title
        } // if let destination {} else {}
    } // private var title: String {}
    
    
    
    
    
} // struct FlightList {]
