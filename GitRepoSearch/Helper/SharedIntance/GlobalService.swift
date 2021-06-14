//
//  GlobalService.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 14/06/2021.
//

import Foundation


class GlobalService {
    
    static let shared = GlobalService()
    
    var recentSearchesArr: [String] = []
    var productModel: ProductModel?
    var searchHistory: [String:ProductModel?] = [:]
}
