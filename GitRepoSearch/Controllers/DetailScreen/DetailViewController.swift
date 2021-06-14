//
//  DetailViewController.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var userModel: RepoInfoModel?
//    private var presenter: DetailPresenter!
    
    // MARK: - Outlets
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    // MARK: - Button Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func urlButtonAction(_ sender: Any) {
//        let url = URL(string: userModel?.html_url ?? "")
        
        if let encoded = userModel?.html_url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encoded)
        {
            print(url)
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)

        }
    }
    
    @IBAction func profilePicBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: ImageViewController.identifier) as? ImageViewController {
            if let model = userModel {
                vc.userImageString = model.owner?.avatar_url ?? ""
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterSetup()
        setupNavigation()
        setupUserData()
    }
    
    /// Function to setup presenter
    private func presenterSetup() {
//        self.presenter = DetailPresenter(view: self)
    }
    
    /// Function to setup navigation
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        self.statusView.createGradientLayer()
        self.headerView.createGradientLayer()
    }
    
    /// FUnctio to setup user data
    private func setupUserData() {
        if let model = userModel {
            var imageURL: URL? = nil
            let imageData = model.owner?.avatar_url ?? ""
            if let url: URL =  URL(string: imageData) {
                imageURL = url
            }
            
            if imageURL != nil {
                self.profileBackgroundImage.kf.setImage(with: imageURL)
                self.profileImage.kf.setImage(with: imageURL)
            } else {
                self.profileImage.image = #imageLiteral(resourceName: "placeholderIcon")
            }
//            self.profileBackgroundImage.image = #imageLiteral(resourceName: "background")
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = profileBackgroundImage.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            profileBackgroundImage.addSubview(blurEffectView)
            self.titleLabel.text = "Repo " + "\(model.name ?? "")"
            self.lastNameLabel.text = model.description ?? ""
            self.urlButton.setTitle(model.html_url ?? "", for: .normal)
            self.languageLabel.text = model.language ?? ""
        }
        
    }

}
