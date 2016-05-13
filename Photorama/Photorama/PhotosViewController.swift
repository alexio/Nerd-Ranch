//
//  ViewController.swift
//  Photorama
//
//  Created by Alexio Mota on 5/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchInterestingPhotos() {
            (photosResult: PhotosResult) -> Void in
            
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) interesting photos.")
                self.loadPhoto(photos)
            case let .Failure(error):
                print("Error fetching interesting photos: \(error)")
            }

        }
    }
    
    private func loadPhoto(photos: [Photo]) -> () {
        if let firstPhoto = photos.first {
            store.fetchImageForPhoto(firstPhoto) {
                (imageResult) -> Void in
                switch imageResult {
                case let .Success(image):
                    print("Fetched the image")
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.imageView.image = image
                    }
                case let .Failure(error):
                    print("Error downloading image: \(error)")
                }
            }
        }
    }
}


