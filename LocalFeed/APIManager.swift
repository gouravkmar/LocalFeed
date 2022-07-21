//
//  APIManager.swift
//  LocalFeed
//
//  Created by New User on 15/07/22.
//

import Foundation

protocol APIProtocol {
    var apiEndpoint : String { get }
    func didFetchSuccessfully(response : Data, params : [String:Any]?)
    func didFail(error : Error?)
    func parse(response : [String:Any])
    func getParams()->[String:Any]?
    
}
class APIManager{
    
    
    func makeAPIRequest(delegate : APIProtocol){
        let apiEndpoint = delegate.apiEndpoint
        let params = delegate.getParams()
        
        var urlComponents = URLComponents(string: GooglePlacesAPIBaseURL+apiEndpoint)
        //        urlComponents.scheme = "https"
        //        urlComponents.host = GooglePlacesAPIBaseURL+apiEndpoint
        
        params?.forEach { querryKey,querryValue in
            let urlQuerryItem = URLQueryItem(name: querryKey, value: querryValue as? String)
            if urlComponents?.queryItems == nil {
                urlComponents?.queryItems = [urlQuerryItem]
            }else
            {
                urlComponents?.queryItems?.append(urlQuerryItem)
            }
        }
        urlComponents?.queryItems?.append(URLQueryItem(name: "key", value: GoogleAPIKey))
        if let url = urlComponents?.url
        {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){data , response, error in
                
                if error != nil {
                    DispatchQueue.main.async {
                        delegate.didFail(error: error)
                    }
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        delegate.didFetchSuccessfully(response: data, params: params)
                    }
                }
            }.resume()
        }else
        {
            print("invalid URL")
            return
        }
        
        
    }
    
    
    
}
