//
//  BasicCell.swift
//  LocalFeed
//
//  Created by New User on 17/07/22.
//

import UIKit

class BasicCell: UICollectionViewCell{
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    static let cellID = "basicCell"
    var photoReference : String?  {
        didSet {
            
            refreshCellData()
            
        }
    }
    override func prepareForReuse() {
        photoReference = nil
        imageView.image = UIImage(named: "no_image")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "no_image")
        imageView.image = image
        //        imageView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        // Initialization code
    }
    func refreshCellData(){
        if photoReference != nil
        {
            APIManager().makeAPIRequest(delegate: self)
        }
    }
    
    
}
extension BasicCell : APIProtocol{
    var apiEndpoint: String {
        return "photo"
    }
    
    func didFetchSuccessfully(response: Data, params: [String : Any]?) {
        print(response)
        if let image = UIImage(data: response)
            
        {
            imageView.layoutIfNeeded()
            imageView.layer.cornerRadius = CGFloat(5)
            imageView.layer.masksToBounds = true
            imageView.image = image
            
        }
        
        //        self.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        if let json = try?  JSONSerialization.jsonObject(with: response, options: []){
            print(json)
        }
    }
    
    func didFail(error: Error?) {
        print(error ?? "")
    }
    
    func parse(response: [String : Any]) {
        print(response)
    }
    
    func getParams() -> [String : Any]? {
        let params  = [
            "photo_reference" : photoReference,
            "maxheight" : "100",
            "maxwidth" : "100"
        ]
        return params
    }
    
    
}
