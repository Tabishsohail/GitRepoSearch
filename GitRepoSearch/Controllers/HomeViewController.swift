//
//  HomeViewController.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import UIKit

class HomeViewController: UIViewController, HomePresenterProtocol {

    // MARK: - Properties
//    lazy var slideTransitioningDelegate: SlideInPresentationManager = SlideInPresentationManager()
    let searchController = UISearchController(searchResultsController: nil)
    private var presenter: HomeViewModel!
    private var filteredArray: [RepoInfoModel?] = []
    var type : UrlType!


    
    //MARK: OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var noResultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Functions
    private func initialSetup() {
        setUpNavigationTitle()
        presenterSetup()
       
        registerTableCell()
        setupTableView()

        registerForPreviewing(with: self, sourceView: tableView)
        self.noResultLabel.text = "Please enter language or topic to search GitHub"
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationTitle()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()

        }
    }
    
    /// Function to setup navigation title
    private func setUpNavigationTitle() {
        self.title = "Search Repositories"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0 / 255.0, green: 84 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0 / 255.0, green: 84 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Admin", style: .plain, target: self, action: #selector(onAdminClicked))
        navigationItem.rightBarButtonItem?.tintColor = .white
        setUpSearchController()

       
    }
    
    @objc func onAdminClicked(_ sender: Any){
        print("onAdminClicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: AdminViewController.identifier) as? AdminViewController {
//            vc.userModel = cellModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// Function to setup presenter
    private func presenterSetup() {
        self.presenter = HomeViewModel(with: self)
    }
    
    /// Function to setup search controller
    private func setUpSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Language"
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.white
        
        // TextField Color Customization
        /*
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            if let backgroundview = textFieldInsideSearchBar.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }*/
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
//        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView?.layoutSubviews()
        definesPresentationContext = true
        
    }
    
    /// Function to register table cell
    private func registerTableCell() {
        self.tableView.registerCell(RepoTableViewCell.identifier)
    }
    
    /// Function to setup table view
    private func setupTableView() {
        // Add Refresh Control to Table View
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = refreshControl
//        } else {
//            tableView.addSubview(refreshControl)
//        }
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    /// Function to get all user data
    private func getAllUserData() {
//        presenter.getAllRepoList()
    }
    
    
    /// Function to check if search bar is empty or not
    /// - Returns: bool
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Function to filter search text
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(debounceSearch),
                                               object: nil)
        
        perform(#selector(debounceSearch), with: nil, afterDelay: TimeInterval(1))


//       {

//            tableView.reloadData()
//        }
    }
    
    /// Function to check if filtering is active
    /// - Returns: bool
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    @IBAction func segmentChanges(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                print("First Segment Selected")
                searchController.searchBar.placeholder = "Search by Language"

            case 1:
                print( "Second Segment Selected")
                searchController.searchBar.placeholder = "Search by Topic"

            default:
                break
            }
    }
    
    
    
    func ListOfRepoResponseRecieved(modal:[RepoInfoModel?],status:Bool){
        if status {
            
//            filteredArray = modal.filter({( model : RepoInfoModel?) -> Bool in
//                let userName = model.firstName + " " + model.lastName
//                return userName.lowercased().contains(searchText.lowercased())
//            })
            DispatchQueue.main.async {
                
                self.reloadTableView()
            }
        } else {
            DispatchQueue.main.async {
//                self.alert(message: "An error has occurred, Please try again")
            }
        }
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    // MARK: - Tableview methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
//        if isFiltering() {
//            rowCount = self.filteredArray.count
//        } else {
            rowCount = self.presenter.numberOfRows
//        }
        if rowCount > 0 {
            self.noResultLabel.isHidden = true
        } else {
            self.noResultLabel.isHidden = false
            self.noResultLabel.text = "No Results Found.\nPlease try to broaden your search"
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier) as? RepoTableViewCell else {
            fatalError("Cell not found")
        }
        if let cellModel = presenter.getRepoDataModelAtIndex(index: indexPath.row) {
            let userIndexData: RepoInfoModel
//            if isFiltering() {
//                userIndexData = filteredArray[indexPath.row]
//            } else {
                userIndexData = cellModel
//            }
            cell.setupData(model: userIndexData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = presenter.getRepoDataModelAtIndex(index: indexPath.row) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController {
                vc.userModel = cellModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let height:CGFloat = 300
           
            return height
        }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 20 {
//            if presenter
            if presenter.numberOfRows > 0{
                presenter.paginationHit(selectedIndex: segmentedControl.selectedSegmentIndex, searchText: searchController.searchBar.text ?? "", isPaginationReq: true)

            }
        }
    }
    
    private func createDetailViewControllerIndexPath(indexPath: IndexPath) -> DetailViewController {
        
        let detailViewController = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        if let cellModel = presenter.getRepoDataModelAtIndex(index: indexPath.row) {
            detailViewController.userModel = cellModel
        }
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        let detailViewController = createDetailViewControllerIndexPath(indexPath: indexPath)
        return detailViewController
    }

    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}



extension HomeViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    @objc private func debounceSearch(_ sender: UISearchBar) {
          print("finally called once!")
        
        guard let searchText = searchController.searchBar.text
        else{
            return
        }
        
        if searchText.count > 2 {
            presenter.getRepoArray(selectedIndex: segmentedControl.selectedSegmentIndex, searchText: searchText, callBack: self.ListOfRepoResponseRecieved(modal:status:))

        }
       

    }
}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension HomeViewController: AlertViewProtocol {
    
    
    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    
}
