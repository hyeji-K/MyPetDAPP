//
//  Product.swift
//  MyPetD
//
//  Created by heyji on 3/5/25.
//

import Foundation

struct Product: Equatable, Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var expirationDate: String
    var imageUrl: String
    var storedMethod: String
    var memo: String
    var catPreference: Int
    var price: String
    var category: String
    var state: String
    let createdAt: String
    var updateAt: String
    
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id,
                                   "name": name,
                                   "expirationDate": expirationDate,
                                   "imageUrl": imageUrl,
                                   "storedMethod": storedMethod,
                                   "memo": memo,
                                   "catPreference": catPreference,
                                   "price": price,
                                   "category": category,
                                   "state": state,
                                   "createdAt": createdAt,
                                   "updateAt": updateAt]
        return dict
    }
    
    mutating func update(name: String, expirationDate: String, imageUrl: String, storedMethod: String, memo: String, catPreference: Int, price: String, category: String, state: String, updateAt: String) {
        self.name = name
        self.expirationDate = expirationDate
        self.imageUrl = imageUrl
        self.storedMethod = storedMethod
        self.memo = memo
        self.catPreference = catPreference
        self.price = price
        self.category = category
        self.state = state
        self.updateAt = updateAt
    }
}

class ProductManager {
    var products: [Product] = []
    
    func createProduct() -> Product {
        let today = Date.now.stringFormat
        return Product(name: "",
                       expirationDate: today,
                       imageUrl: "",
                       storedMethod: "",
                       memo: "",
                       catPreference: 0,
                       price: "",
                       category: "기타",
                       state: "true",
                       createdAt: today,
                       updateAt: today)
    }
    
    func addProduct(_ productData: Product) {
        products.append(productData)
    }
    
    func deleteProduct(with id: Product.ID) {
        products = products.filter({
            $0.id != id
        })
    }
    
    func updateProduct(_ productData: Product) {
        guard let index = products.firstIndex(of: productData) else { return }
        products[index].update(name: productData.name,
                               expirationDate: productData.expirationDate,
                               imageUrl: productData.imageUrl,
                               storedMethod: productData.storedMethod,
                               memo: productData.memo,
                               catPreference: productData.catPreference,
                               price: productData.price,
                               category: productData.category,
                               state: productData.state,
                               updateAt: Date().stringFormat)
    }
}
