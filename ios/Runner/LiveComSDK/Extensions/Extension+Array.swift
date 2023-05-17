//
//  Extension+Array.swift
//  Runner
//
//  Created by Sakhabaev Egor on 15.05.2023.
//

import Foundation

extension Array {
    func get(_ index: Int) -> Element? {
        if (0..<count).contains(index) {
            return self[index]
        }
        return nil
    }
}
