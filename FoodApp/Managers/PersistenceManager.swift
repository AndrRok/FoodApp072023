//
//  PersistenceManager.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import Foundation
import RealmSwift


final class CartItemsRealm: Object{
    @Persisted dynamic var nameOfItem   = String()
    @Persisted dynamic var imageUrl     = String()
    @Persisted dynamic var price        = Int()
    @Persisted dynamic var weight       = Int()
    @Persisted dynamic var amountInCart = Int()
    @Persisted dynamic var idOfItem     = String()//primary key (not for sorting)
    override static func primaryKey() -> String? { return "idOfItem" }
    @Persisted(primaryKey: true) var id: ObjectId//for sorting
}

class PersistenceManager{
    static let sharedRealm = PersistenceManager()
    private let realm = try! Realm()
    var inCartItem: Results<CartItemsRealm> {return realm.objects(CartItemsRealm.self).sorted(byKeyPath: "id", ascending: false)}//sorting
    
    func inCartObjectExist(primaryKey: String) -> Bool {//check if object already exists
        return realm.object(ofType: CartItemsRealm.self, forPrimaryKey: primaryKey) != nil
    }
    
    func addToCart(item: Dishes, amount: Int ){
        let inCartItem = CartItemsRealm()
                inCartItem.nameOfItem = item.name
                inCartItem.imageUrl    = item.imageUrl
                inCartItem.price = item.price
        inCartItem.weight = item.weight
                inCartItem.amountInCart = amount
        inCartItem.idOfItem   = String(item.id)//primary key
        
        try! realm.write{ realm.add(inCartItem) }
    }
    
    func editObjectAt(idForEdit: String, increase: Bool){
        let realm = try! Realm()
        let data = realm.object(ofType: CartItemsRealm.self, forPrimaryKey: idForEdit)
        if data != nil{
            try! realm.write {
                guard increase else {
                    data?.amountInCart -= 1
                    return
                }
                data?.amountInCart += 1
            }
        }
    }
    
    func deleteFromCart(item: CartItemsRealm){
        try! realm.write{
            realm.delete(item) }
    }
    
    func deleteDataFromCart(idForDelete: String){
        let realm = try! Realm()
        let data = realm.object(ofType: CartItemsRealm.self, forPrimaryKey: idForDelete)
        if data != nil{
            try! realm.write {
                realm.delete(data!)
            }
        }
    }
}
