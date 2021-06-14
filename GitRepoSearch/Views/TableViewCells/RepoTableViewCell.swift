//
//  RepoTableViewCell.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import UIKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    @IBOutlet weak var seenImageView: UIImageView!
    @IBOutlet weak var seenLabel: UILabel!
    @IBOutlet weak var forkImageView: UIImageView!
    @IBOutlet weak var forkLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productView.shadowPath(cornerRadius: 10)
        userProfileImage.makeRounded()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// Function to set data in cells
    /// - Parameters:
    ///   - indexPath: takes user model as input
    func setupData(model: RepoInfoModel) {
        var imageURL: URL? = nil
        let imageData = model.owner?.avatar_url ?? ""
        if let url: URL =  URL(string: imageData) {
            imageURL = url
        }
        
        if imageURL != nil {
            self.userProfileImage.kf.setImage(with: imageURL)
        } else {
            self.userProfileImage.image = #imageLiteral(resourceName: "placeholderIcon")
        }
        self.repoName.text = model.name
        self.repoDescriptionLabel.text = "\(model.description ?? "")"
        self.seenLabel.text = "\(model.watchers ?? 0)"
        self.forkLabel.text = "\(model.forks ?? 0)"
    }
    
}
