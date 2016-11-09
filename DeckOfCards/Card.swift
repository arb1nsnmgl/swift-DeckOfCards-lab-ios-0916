//
//  Card.swift
//  DeckOfCards
//
//  Created by Arvin San Miguel on 11/7/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    let imageURLString : String
    let url: URL?
    let code: String
    var image: UIImage?
    let value: String
    let suit: String
    let apiClient = CardAPIClient.shared
    var isDownloading = false
    
    init(dictionary values: JSON) {
        
        self.imageURLString = values["image"] as! String
        self.value = values["value"] as! String
        self.suit = values["suit"] as! String
        self.code = values["code"] as! String
        self.url = URL(string: imageURLString)
        
        
    }
    
    func downloadImage(_ handler: @escaping (Bool) -> Void ) {
        
        if let url = url {
            
            apiClient.downloadImage(at: url, handler: { success, image in
                guard let image = image else { return }
                OperationQueue.main.addOperation {
                    self.image = image
                    handler(true)
                }
            })
            
        }
    }
    
    
}
