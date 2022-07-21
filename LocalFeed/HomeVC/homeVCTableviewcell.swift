//
//  homeVCTableviewcell.swift
//  LocalFeed
//
//  Created by New User on 21/07/22.
//

import UIKit

class homeVCTableviewcell: UITableViewCell {

    var data : keywordAndplaces? {
        didSet {
            refreshCollectionView()
        }
    }
    static let reuseID  = "homeVCTableviewCell"
    @IBOutlet weak var cellCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellCollectionView.delegate = self
        cellCollectionView.dataSource = self
        cellCollectionView.register(UINib(nibName: "BasicCell", bundle: nil), forCellWithReuseIdentifier: BasicCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func refreshCollectionView(){
        cellCollectionView.reloadData()
    }
    
}
extension homeVCTableviewcell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.places.results.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = cellCollectionView.dequeueReusableCell(withReuseIdentifier: BasicCell.cellID, for: indexPath) as! BasicCell
        let placeItem = data?.places.results[indexPath.row]
        cell.mainLabel.text = placeItem?.name
        if let reference = placeItem?.photos?.first?.photoReference
        {
            cell.photoReference = reference
        }
        return cell
    }
    
    
    
}
