//
//  ProductInfo.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import Foundation

struct ProductInfo: Equatable, Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var image: String
    var name: String
    var expirationDate: String
    var storedMethod: String
    var memo: String
//    let category: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "image": image, "name": name, "expirationDate": expirationDate, "storedMethod": storedMethod, "memo": memo]
        return dict
    }
}

extension Array where Element == ProductInfo {
    func indexOfProduct(with id: ProductInfo.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

extension ProductInfo {
    static let list = [
        ProductInfo(id: "1", image: "Ellipse5", name: "차오츄르", expirationDate: "2022-10-18 23:00:00", storedMethod: "냉장고", memo: "우리 고양이가 짱 좋아하는 츄르!"),
        ProductInfo(id: "2", image: "Ellipse4", name: "로얄캐닌 인도어", expirationDate: "2022-10-18 23:00:00", storedMethod: "실온", memo: "우리 고양이가 짱 좋아하는 사료!"),
        ProductInfo(id: "3", image: "Ellipse3", name: "어쩌구 캔", expirationDate: "2022-10-18 23:00:00", storedMethod: "서랍", memo: "우리 고양이가 짱 좋아하는 캔!"),
        ProductInfo(id: "4", image: "Ellipse2", name: "네모북어", expirationDate: "2022-10-18 23:00:00", storedMethod: "냉장고", memo: "우리 고양이가 짱 좋아하는 트릿!"),
        ProductInfo(id: "5", image: "Ellipse1", name: "닭가슴살", expirationDate: "2022-10-18 23:00:00", storedMethod: "서랍", memo: "우리 고양이가 짱 좋아하는 간식!"),
    ]
}
