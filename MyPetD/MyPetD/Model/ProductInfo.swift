//
//  ProductInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import Foundation

struct ProductInfo: Hashable, Identifiable, Codable {
    let id: Int
    let imageOfProduct: String
    let nameOfProduct: String
    let expirationDate: String // Date 
    let storedMethod: String
//    let category: String
    let memo: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "imageOfProduct": imageOfProduct, "nameOfProduct": nameOfProduct, "expirationDate": expirationDate, "storedMethod": storedMethod, "memo": memo]
        return dict
    }
    
    static var id: Int = 0
}

extension ProductInfo {
    static let list = [
        ProductInfo(id: 1, imageOfProduct: "Ellipse5", nameOfProduct: "차오츄르", expirationDate: "2022.01.02", storedMethod: "냉장고", memo: "우리 고양이가 짱 좋아하는 츄르!"),
        ProductInfo(id: 2, imageOfProduct: "Ellipse4", nameOfProduct: "로얄캐닌 인도어", expirationDate: "2022.01.02", storedMethod: "실온", memo: "우리 고양이가 짱 좋아하는 사료!"),
        ProductInfo(id: 3, imageOfProduct: "Ellipse3", nameOfProduct: "어쩌구 캔", expirationDate: "2022.01.02", storedMethod: "서랍", memo: "우리 고양이가 짱 좋아하는 캔!"),
        ProductInfo(id: 4, imageOfProduct: "Ellipse2", nameOfProduct: "네모북어", expirationDate: "2022.01.02", storedMethod: "냉장고", memo: "우리 고양이가 짱 좋아하는 트릿!"),
        ProductInfo(id: 5, imageOfProduct: "Ellipse1", nameOfProduct: "닭가슴살", expirationDate: "2022.01.02", storedMethod: "서랍", memo: "우리 고양이가 짱 좋아하는 간식!"),
    ]
}
