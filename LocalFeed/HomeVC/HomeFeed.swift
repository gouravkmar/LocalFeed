//
//  HomeFeed.swift
//  LocalFeed
//
//  Created by New User on 15/07/22.
//

import Foundation
import CoreLocation
import UIKit
class HomeFeed : APIProtocol{
    
    internal var apiEndpoint: String = "nearbysearch/json"
    private var radius  = 10000 //default , can be changed by VC or by notif
    private (set) var  allPlaces : [keywordAndplaces]
    private var searchKeyword  : String
    private var allSearchItems : [String]
    func didFetchSuccessfully(response: Data, params: [String : Any]?) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        do{
            let places = try decoder.decode(placesByKeyword.self, from: response)
            for place in places.results
            {
                let photoRef  = place.photos?.first?.photoReference
                
                
            }
            let image = [UIImage(named: "")]
            let keywordAndPlacesItem = keywordAndplaces(keyWord: params?["keyword"] as? String ?? "Explore", places: places,placeImages: image)
            
            allPlaces.append(keywordAndPlacesItem)
           
                
            NotificationCenter.default.post(name: Notification.Name("localFeed.homeDataUpdated"), object: nil)
            
           
        }catch{
            if let json = try?  JSONSerialization.jsonObject(with: response, options: []){
                print("Parse error")
            }
        }
    }
    
    func didFail(error: Error?) {
        print(error ?? "")
    }
    
    func parse(response: [String : Any]) {
        print(response)
    }
    
    func getParams() -> [String : Any]? {
        
        let location  =  LocationManager.currentLocation
        
        var array : [String : Any ] = [
            "location" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "radius" : "\(radius)"
        ]
        if searchKeyword != "" {
            array["keyword"]  =  "\(searchKeyword)"
        }
        
        return array
    }
    
    @objc  func makeAPIRequestsForItems(){
        for keyword in allSearchItems {
            searchKeyword = keyword
            APIManager().makeAPIRequest(delegate: self)
        }
    }
    
    init() {
        allPlaces = []
        allSearchItems = ["restaurants" , "store", "cafe" , "ice-cream"]
        searchKeyword = allSearchItems.first ?? ""
        initData()
        NotificationCenter.default.addObserver(self, selector: #selector(makeAPIRequestsForItems), name: Notification.Name("localFeed.locationUpdated"), object: nil)
    }
    func initData(){
        allPlaces = []
        if LocationManager.locationAvailable {
            makeAPIRequestsForItems()
        }
    }
    
}


struct keywordAndplaces{
    let keyWord : String
    let places : placesByKeyword
    let placeImages : [UIImage?]
}

struct placesByKeyword :Decodable{
    let nextPageToken : String
    let results : [placeInfo]
    
    
}
struct placeInfo : Decodable {
    let businessStatus  : String
    let placeId : String
    let geometry : Geometry
    let icon : String
    let name : String
    let rating : Double
    let types : [String]
    let userRatingsTotal :Int
    let vicinity : String
    let openingHours : OpeningHours?
    let photos : [Photo]?
    let permanentlyClosed: Bool?
}
struct Geometry : Decodable{
    let location : Location
}
struct Location :Decodable {
    let lat : Double
    let lng : Double
}
struct OpeningHours : Decodable {
    let openNow  :  Bool
}
struct Photo :Decodable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
}


