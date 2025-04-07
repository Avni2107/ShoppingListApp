//
//  ShoppingItem.swift
//  ShoppingApp
//
//

import Foundation

struct ShoppingItem {
    var name: String
    var isPurchased: Bool
    var category: String
    var price: Double
    var quantity: Int

    var summary: String {
        return "\(name) (\(category)) - \(quantity) x $\(price)"
    }
}

