//
//  HomeViewModel.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import Foundation

protocol HomePresenterProtocol: class {
    func reloadTableView()
    func showError(title: String, message: String)
}

class HomeViewModel {
    
    // MARK: - Properties
    private var view: HomePresenterProtocol?
    private var productModel: ProductModel?
    private var page: Int = 1
    
    var listPacket:ApiPacket!
    var getSearchedReposCallback:(([RepoInfoModel?], Bool)->())? = nil
    
    var numberOfRows: Int {
        return productModel?.items.count ?? 0
    }
    var currentSearchText = ""
    
    // MARK: - Methods
    /// Initial setup of presenter
    init(with view: HomePresenterProtocol?) {
        self.view = view
        listPacket = ApiPacket()
        
    }
    
    
    /// Function for pagination hit
    func paginationHit(selectedIndex: Int, searchText: String, isPaginationReq: Bool = false) {
        if isPaginationReq == true {
            page += 1
            self.getRepoArray(isFromPagination: true, selectedIndex: selectedIndex, searchText: searchText) { (model, result) in
                self.view?.reloadTableView()
            }
            
        }
    }
    
    
    /// Function to get the repo model for the particular index
    /// - Parameters:
    ///   - indexPath: takes the indexpath to return model
    /// - Returns: repo detail model for selected index
    func getRepoDataModelAtIndex(index: Int) -> RepoInfoModel? {
        if let model = self.productModel?.items {
            return model[index]
        }
        return nil
    }
    
    /// Function to get repo array all together
    /// - Returns: entire repo array
    func getRepoArray(isFromPagination: Bool = false, selectedIndex: Int, searchText: String , callBack:@escaping ([RepoInfoModel?],Bool)->()) {
        
        var list: UrlType
        var searchStr = searchText
        
        if searchStr == "" || searchStr.count < 1{
            if isFromPagination {
                searchStr = self.currentSearchText
            }else {
                getSearchedReposCallback!([],true)
                return
            }
           
        }
        ///add the search text to the shared array for reference
        GlobalService.shared.recentSearchesArr.append(searchStr)
        self.currentSearchText = searchStr
        
        if selectedIndex == 0{
            list = .byLanguage(searchString: searchStr.replacingOccurrences(of: " ", with: "+"), pageNumber: page)
        }else {
            list = .byTopic(searchString: searchStr.replacingOccurrences(of: " ", with: "+"), pageNumber: page)
            
        }
        
        getSearchedReposCallback = callBack
        listPacket.urlType = list
        listPacket.httpMethod = "GET"
        
        if Reachability.isConnectedToNetwork(){
            ProgressHUD.present(animated: true)
            
            NetworkHandler.shared.getDatafromNetwork(packet:listPacket) { [self] (result, data) in
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss(animated: true)
                    
                }
                
                guard let repoModel = data else {
                    if !isFromPagination {
                        self.productModel = ProductModel(totalCount: 0, incompleteResults: false, items: [])
                        GlobalService.shared.searchHistory[self.currentSearchText] = self.productModel
                        getSearchedReposCallback!([],true)
                    }
                    
                    return
                }
                
                if !isFromPagination {
                    self.productModel = repoModel
                    GlobalService.shared.productModel = repoModel
                    GlobalService.shared.searchHistory[self.currentSearchText] = repoModel
                } else {
                    self.productModel?.items += repoModel.items
                    GlobalService.shared.productModel?.items += repoModel.items
                    GlobalService.shared.searchHistory[self.currentSearchText] = self.productModel
                }
                
                if let items = self.productModel?.items {
                    getSearchedReposCallback!(items ,true)

                }

            }
            
        }else {
            self.view?.showError(title: "", message: "No Internet Connection available.")
        }
        
    }
    
    
    private func handleResponse(status:Bool,data:Data?){
        ProgressHUD.dismiss(animated: true)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let results = try? decoder.decode(ProductModel.self, from: data!){
            
            getSearchedReposCallback!(results.items,true)
        } else {
            getSearchedReposCallback!([],false)
        }
    }
    
    
}
