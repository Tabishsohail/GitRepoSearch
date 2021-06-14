//
//  Dictionary+extention.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 13/06/2021.
//


import Foundation

extension Array {
    func jsonString() -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        
        guard jsonData != nil else {return nil}
        
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        
        guard jsonString != nil else {return nil}
//        jsonDict = jsonDataString
        return jsonString! as String
    }

}
