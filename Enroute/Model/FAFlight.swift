//
//  FAFlight.swift
//  Enroute
//
//  Created by Olivier Van hamme on 27/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation

// json decoded directly from what comes back from FlightAware's "Enroute?"

struct FAFlight: Codable ,
                 Hashable ,
                 Identifiable ,
                 Comparable ,
                 CustomStringConvertible {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    private(set) var ident: String
    private(set) var aircraft: String
    
    private(set) var destination: String
    private(set) var destinationName: String
    private(set) var destinationCity: String
    
    private(set) var origin: String
    private(set) var originName: String
    private(set) var originCity: String
    
    private var actualdeparturetime: Int
    private var estimatedarrivaltime: Int
    private var filed_departuretime: Int
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var number: Int {
        Int(String(ident.drop(while : { !$0.isNumber }))) ?? 0
    } // var number: Int {}
    
    
    var airlineCode: String { String(ident.prefix(while : { !$0.isNumber })) }
    
    
    var departure: Date? {
        actualdeparturetime > 0 ? Date(timeIntervalSince1970: TimeInterval(actualdeparturetime)) : nil
    } // var departure: Date? {}
    
    
    var arrival: Date { Date(timeIntervalSince1970: TimeInterval(estimatedarrivaltime)) }
    
    
    var filed: Date { Date(timeIntervalSince1970: TimeInterval(filed_departuretime)) }
    
    
    var originFullName: String {
        let origin = self.origin.first == "K" ? String(self.origin.dropFirst()) : self.origin
        if originName.contains(elementIn : originCity.components(separatedBy : ",")) {
            return origin + " " + originCity
        }
        return origin + " \(originName), \(originCity)"
    } // var originFullName: String {}
    
    
    var id: String { ident }

    
    var description: String {
        if let departure = self.departure {
            return "\(ident) departed \(origin) at \(departure) arriving \(arrival)"
        } else {
            return "\(ident) scheduled to depart \(origin) at \(filed) arriving \(arrival)"
        }
    } // var description: String {}
    
    
    
     // ////////////
    //  MARK: ENUMS
    
    private enum CodingKeys: String, CodingKey {
        case ident
        case aircraft = "aircrafttype"
        case actualdeparturetime, estimatedarrivaltime, filed_departuretime
        case origin, destination
        case originName, originCity
        case destinationName, destinationCity
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    
    static func ==(lhs: FAFlight ,
                   rhs: FAFlight)
        -> Bool { lhs.id == rhs.id }
    
    
    static func < (lhs: FAFlight ,
                   rhs: FAFlight)
        -> Bool {
            
        if lhs.arrival < rhs.arrival {
            return true
        } else if rhs.arrival < lhs.arrival {
            return false
        } else {
            return lhs.departure ?? lhs.filed < rhs.departure ?? rhs.filed
        } // if {} else if {} else {}
    } // static func < (lhs: FAFlight, rhs: FAFlight) -> Bool {}

   
    
    
    
} // struct FAFlight {}
