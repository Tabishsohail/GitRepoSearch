//
//  AlertViewExtension.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import Foundation
import UIKit

protocol AlertViewProtocol: class {
    func showAlert(title: String, message: String)
}

extension AlertViewProtocol {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
