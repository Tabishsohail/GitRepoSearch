//
//  AdminViewModel.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 14/06/2021.
//

import Foundation


class AdminViewModel {
    
    var numberOfRows: Int{
        return GlobalService.shared.searchHistory.keys.count
    }
    
    /// Function to get the repo model for the particular index
    /// - Parameters:
    ///   - indexPath: takes the indexpath to return model
    /// - Returns: repo detail model for selected index
    func getRepoDataModel(index: Int) -> [RepoInfoModel?] {
//        if let model = GlobalService.shared.productModel?.items {
//            return model[index]
//        }
        return GlobalService.shared.productModel?.items ?? []
    }
    
    func getResultsForText(text: String) -> [RepoInfoModel?]{
        if let model = GlobalService.shared.searchHistory[text] {
            return model?.items ?? []
        }
        return []
    }
}
