//
//  PhotoStore.swift
//  Photorama
//
//  Created by Alexio Mota on 5/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import Foundation

class PhotoStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()

    func fetchInterestingPhotos(completion completion: (photos: PhotosResult) -> ()) {
        let url = FlickrAPI.interestingPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler:  { (data, response, error) -> Void in
            let results = self.processPhotosRequest(data: data, error: error)
            completion(photos: results)
        })
        task.resume()
    }
    
    func processPhotosRequest(data data: NSData?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(jsonData)
    }
}

