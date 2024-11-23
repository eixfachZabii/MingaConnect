//
//  User.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import Foundation


struct User: Codable {
    let id: String
    let username: String
    let profile_pic: String
    //let dateOfBirth: String?
    let interests: [String]
    //let email: String
    //let events: [String]
}
