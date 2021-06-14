//
//  RepoModel.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import Foundation

//
//  RepoModel.swift
//  pagination
//
//  Created by Tabish Sohail on 12/06/2021.
//

import Foundation

struct ProductModel: Codable {

    var totalCount: Int?
    let incompleteResults: Bool?

    var items: [RepoInfoModel?]
    
     enum CodingKeys: String, CodingKey {
        
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct RepoInfoModel: Codable {
    
    var name: String?
    var description: String?
    let forks : Int?
    var watchers: Int?
    var owner: Owner?
    var language: String?
    var html_url: String?
    
     enum CodingKeys: String, CodingKey {

        case name
        case description
        case forks
        case watchers
        case owner
        case language
        case html_url
    }
}

struct Owner: Codable {
    
    let login: String?
    let id: Int?
    let avatar_url: String?
    let publicRepos : Int?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatar_url
        case publicRepos = "public_repos"
    }
}
