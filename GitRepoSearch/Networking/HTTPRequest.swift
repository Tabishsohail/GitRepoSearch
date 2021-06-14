//
//  HTTPRequest.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 12/06/2021.
//

import Foundation



var BASE_URL = "https://api.github.com/search/repositories?q="

struct Services {

//    static let apiKey = "apikey=8fd21c6"
}


class NetworkHandler {
    private init(){
        
    }
    static var shared = NetworkHandler()
    func getDatafromNetwork(packet:ApiPacket, completion:@escaping (Bool,ProductModel?)->()) {
        
        let urlString = packet.getUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        guard let url = URL(string: urlString!) else {return}
        var request = URLRequest(url: URL(string: urlString ?? "")!)
        request.httpMethod = packet.httpMethod!
        request.allHTTPHeaderFields = packet.headers
        
        guard let encoded = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded)
        else  {
            completion(false, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error{
                completion(false, nil)
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(false, nil)
                return
            }
            
            guard let responseData = data else {
                completion(false, nil)
                return
            }
            
            let decoder = JSONDecoder()

            do{
                
                 let results = try decoder.decode(ProductModel.self, from: responseData)
                
                completion(true, results)
                
            }catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }

        }
        

        
        task.resume()
    }
    

}


enum UrlType{
    case byLanguage (searchString : String , pageNumber : Int)
    case byTopic (searchString : String , pageNumber : Int)
}

protocol Packet {
    var httpMethod:String!{get set}
    func getUrl()->String
    var headers:[String:String]?{get set}
    var parameters:[String:Any]?{get set}
    var urlType:UrlType!{get}
}

extension Packet{
    func getUrl()->String{
        switch urlType {
        case .byLanguage(let searchString , let pageNumber):
            return  BASE_URL + "language:\(searchString)&page=\(pageNumber)" + "&per_page=10"
        case .byTopic(let searchString , let pageNumber):
            return BASE_URL + "topic:\(searchString)&page=\(pageNumber)" + "&per_page=10"
        case .none:
            return ""
        }
        
    }
}

struct ApiPacket:Packet{
    var headers: [String : String]?
    var parameters: [String : Any]?
    var urlType: UrlType!
    var httpMethod: String!
    
}
