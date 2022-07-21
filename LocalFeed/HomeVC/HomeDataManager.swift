//
//  HomeDataManager.swift
//  LocalFeed
//
//  Created by New User on 15/07/22.
//

import Foundation

class HomeDataManager {
    
    let homeFeed = HomeFeed()
    func reloadHomedata()
    {
        homeFeed.initData()
    }
}
