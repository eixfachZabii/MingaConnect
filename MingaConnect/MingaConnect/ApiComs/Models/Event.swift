//
//  Event.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import Foundation


struct Event: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    //let picture: String
    let event_date: String?
    //let createDate: String?*/
    let location: [[Double]]
    let host: String
   //let participants: [String]
    let interests: [String]
}
