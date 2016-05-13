//
//  ViewController.swift
//  Photorama
//
//  Created by Alexio Mota on 5/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchInterestingPhotos() {
            (photosResult: PhotosResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.updatePhotoDataSource(photosResult)
            }
        }
    }
    
    private func updatePhotoDataSource(photosResult: PhotosResult) {
        switch photosResult {
        case let .Success(photos):
            print("Successfully found \(photos.count) interesting photos.")
            photoDataSource.photos = photos
        case let .Failure(error):
            print("Error fetching interesting photos: \(error)")
            photoDataSource.photos.removeAll()
        }
        collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    func collectionView(collectionView: UICollectionView,
                        willDisplayCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImageForPhoto(photo) { (result) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                // The index path for the photo might have changed between the
                // time the request started and finished, so find the most
                // recent index path
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forItem: photoIndex, inSection: 0)
                // When the request finishes, only update the cell if it's still visible
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            }
        }
    }
}


