//
//  UserModel.swift
//  NextDayTaskApp
//
//  Created by Sourabh Modi on 31/03/25.
//

import Foundation


struct UserModel: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [UserDetails]
}
struct UserDetails: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}
