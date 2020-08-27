//
//  FlightsEnrouteView.swift
//  Enroute
//
//  Created by Olivier Van hamme on 27/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct FlightsEnrouteView: View {
    
     // //////////////////
    //  PROPERTY WRAPPERS
    
    @State var flightSearch: FlightSearch
    @State private var showFilter = false
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            FlightList(flightSearch)
                .navigationBarItems(leading : simulation ,
                                    trailing : filter)
        } // NavigationView {}
    } // var body: some View {}
    
    
    var filter: some View {
        Button("Filter") {
            self.showFilter = true
        } // Button("Filter") {}
        .sheet(isPresented : $showFilter) {
            FilterFlights(flightSearch : self.$flightSearch ,
                          isPresented : self.$showFilter)
        } // .sheet(isPresented) {}
    } // var filter: some View {}
    
    
    // if no FlightAware credentials exist in Info.plist
    // then we simulate data from KSFO and KLAS (Las Vegas, NV)
    // the simulation time must match the times in the simulation data
    // so, to orient the UI, this simulation View shows the time we are simulating
    var simulation: some View {
        let isSimulating = Date.currentFlightTime.timeIntervalSince(Date()) < -1
        return Text(isSimulating ? DateFormatter.shortTime.string(from: Date.currentFlightTime) : "")
    } // var simulation: some View {}
    
    
    
} // struct FlightsEnrouteView: View {}





 // ///////////////
//  MARK: PREVIEWS

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
    }
}
