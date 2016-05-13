//
//  PhotoStore.swift
//  Photorama
//
//  Created by Alexio Mota on 5/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError : ErrorType {
    case ImageCreationError
}

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
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> ()) {
        let url = photo.remoteURL
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let result: ImageResult = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            
            completion(result)
        })
        task.resume()
    }
    
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult{
        guard let
            imageData = data,
            image = UIImage(data: imageData) else {
                // Couldn't create an image
                if data == nil {
                    return .Failure(error!)
                }
                else {
                    return .Failure(PhotoError.ImageCreationError)
                }
        }
        
        return .Success(image)
    }
}

