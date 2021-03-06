//
//  ImageViewController.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: - Properties
    var userImageString = ""
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - Button Action
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = UIColor.black
        var imageURL: URL? = nil
        let imageData = self.userImageString
        if let url: URL =  URL(string: imageData) {
            imageURL = url
        }
        
        if imageURL != nil {
            self.profileImage.kf.setImage(with: imageURL)
        } else {
            self.profileImage.image = #imageLiteral(resourceName: "placeholderIcon")
        }
    }

}
