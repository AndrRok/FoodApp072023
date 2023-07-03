//
//  DishesItem.swift
//  FoodApp
//
//  Created by ARMBP on 7/3/23.
//

import Foundation

struct DishesResponse: Codable, Hashable{
    let dishes: [Dishes]
}

struct Dishes: Codable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case id, name, price, weight, description, imageUrl, tegs }
    let id: Int
    let name: String
    let price: Int
    let weight: Int
    let description: String
    let imageUrl: String
    let tegs: [String]
}

extension Dishes: Hashable{
    static func ==(lhs: Dishes, rhs: Dishes) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

