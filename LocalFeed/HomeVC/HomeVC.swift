//
//  HomeVC.swift
//  LocalFeed
//
//  Created by New User on 15/07/22.
//

import UIKit

class HomeVC: UIViewController {
    
    
    let homeData : HomeDataManager
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var homeVCTableview: UITableView!
    @IBOutlet weak var homeVCCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVCTableview.delegate = self
        homeVCTableview.dataSource = self
        homeVCTableview.register(UINib(nibName: "homeVCTableviewcell", bundle: nil), forCellReuseIdentifier: homeVCTableviewcell.reuseID)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshdata), name: Notification.Name("localFeed.homeDataUpdated"), object: nil)
        
        refreshControl.addTarget(self, action: #selector(pullDownTorefresh), for: .valueChanged)
        homeVCTableview.addSubview(refreshControl)
    }
    required init?(coder: NSCoder) {
        homeData = HomeDataManager()
        let locationManager = LocationManager()
        super.init(coder: coder)
    }
    @objc func pullDownTorefresh(){
        homeData.reloadHomedata()
        refreshdata()
        refreshControl.endRefreshing()
    }
    @objc func refreshdata(){
        homeVCTableview.reloadData()
    }
}

//extension HomeVC : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return homeData.homeFeed.allPlaces[section].places.results.count
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return homeData.homeFeed.allPlaces.count
//    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: 100, height: 100)
////    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 400, height: 40)
//    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let header  = homeVCCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: homeCollectionviewHeader.cellID, for: indexPath)
//            guard let headerView = header as? homeCollectionviewHeader else {
//                return header
//            }
//            headerView.mainLabel.text = homeData.homeFeed.allPlaces[indexPath.section].keyWord
//            return headerView
//        default : assert(false,"invalid element type")
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = homeVCCollectionView.dequeueReusableCell(withReuseIdentifier: BasicCell.cellID, for: indexPath) as! BasicCell
//        let placeItem = homeData.homeFeed.allPlaces[indexPath.section].places.results[indexPath.row]
//        cell.mainLabel.text = placeItem.name
//        if placeItem.name == "Latenight cuisine"
//        {
//            print("late")
//        }
//        if let reference = placeItem.photos?.first?.photoReference
//        {
//            cell.photoReference = reference
//        }
//            return cell
//    }
//}
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeData.homeFeed.allPlaces.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeData.homeFeed.allPlaces[section].keyWord
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeVCTableview.dequeueReusableCell(withIdentifier: homeVCTableviewcell.reuseID, for: indexPath) as? homeVCTableviewcell
        cell?.data = homeData.homeFeed.allPlaces[indexPath.section]
        return cell!
    }
    
    
}
