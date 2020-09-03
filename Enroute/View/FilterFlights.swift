//
//  FilterFlights.swift
//  Enroute
//
//  Created by Olivier Van hamme on 27/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
//    @ObservedObject var allAirports = Airports.all
//    @ObservedObject var allAirlines = Airlines.all
//    @FetchRequest(fetchRequest: Airport.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>

    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Destination", selection: $draft.destination) {
//                    ForEach(allAirports.codes, id: \.self) { airport in
//                        Text("\(self.allAirports[airport]?.friendlyName ?? airport)").tag(airport)
                    ForEach(airports.sorted() , id : \.self) { airport in
                        Text("\(airport.friendlyName)").tag(airport)
                    } // ForEach() {}
                } // Picker("Destination", selection: $draft.destination) {}
                
                
                Picker("Origin", selection: $draft.origin) {
//                    Text("Any").tag(String?.none)
//                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
//                        Text("\(self.allAirports[airport]?.friendlyName ?? airport ?? "Any")").tag(airport)
//                    }
                    Text("Any").tag(Airport?.none)
                    ForEach(airports.sorted() , id : \.self) { (airport: Airport?) in
                        Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                    } // ForEach() {}
                } // Picker("Origin", selection: $draft.origin) {}
                
                
                Picker("Airline", selection: $draft.airline) {
//                    Text("Any").tag(String?.none)
//                    ForEach(allAirlines.codes, id: \.self) { (airline: String?) in
//                        Text("\(self.allAirlines[airline]?.friendlyName ?? airline ?? "Any")").tag(airline)
//                    }
                    Text("Any").tag(Airline?.none)
                    ForEach(airlines.sorted() , id : \.self) { (airline: Airline?) in
                        Text("\(airline?.friendlyName ?? "Any")").tag(airline)
                    }
                }
                Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
            }
            .navigationBarTitle("Filter Flights")
                .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        } // Button("Cancel") {}
    } // var cancel: some View {}
    
    
    var done: some View {
        Button("Done") {
            if self.draft.destination != self.flightSearch.destination {
                self.draft.destination.fetchIncomingFlights()
            }
            
            self.flightSearch = self.draft
            self.isPresented = false
        } // Button("Done") {}
    } // var done: some View {}
    
    
    
    
    
} // struct FilterFlights: View {}
