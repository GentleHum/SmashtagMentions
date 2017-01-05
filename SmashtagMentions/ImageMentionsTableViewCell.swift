//
//  ImageMentionsTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class ImageMentionsTableViewCell: UITableViewCell {
    
    // MARK: outlets
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    var imageSource: MediaItem? {
        didSet {
            if self.window != nil {
                fetchImage()
            }

            updateUI()
        }
    }
    
    private func updateUI() {
        cellImageView?.image = nil
        
        // load new information from our image (if any)
        if let imageSource = self.imageSource {
            cellImageView?.image = nil
        }
    }
    
    private func fetchImage() {
        let myImageURL = imageSource?.url
        if let url = myImageURL {
//            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url as URL) as? Data
                DispatchQueue.main.async {
                    if url == myImageURL {
                        print("checking imageData") // zap
                        if let imageData = contentsOfURL {
                            print("Setting the image") // zap
                            self.cellImageView.image = UIImage(data: imageData)
                        } else {
//                            self.spinner?.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")  // zap
                    }
                    
                }
            }
            
        }
    }

    
}
