//
//  FoodItem.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//


import Foundation

struct FoodItemResponse: Codable, Hashable{
    let сategories: [FoodItems]
}

struct FoodItems: Codable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case id, name, imageUrl }
    let id: Int
    let name: String
    let imageUrl: String
}

extension FoodItems: Hashable{
    static func ==(lhs: FoodItems, rhs: FoodItems) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
