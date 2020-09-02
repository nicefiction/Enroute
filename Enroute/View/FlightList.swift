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
        let request  = Flight.fetchRequest(NSPredicate(format: "destination_CoreData = %@" , flightSearch.destination))
        
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
    }
    
    private var title: String {
        let title = "Flights"
        if
            let destination = flights.first?.destination {
            
            return title + " to \(destination)"
        } else {
            return title
        }
    }
}
