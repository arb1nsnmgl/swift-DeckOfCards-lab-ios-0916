//
//  CardAPIClient.swift
//  DeckOfCards
//
//  Created by Arvin San Miguel on 11/7/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//


import Foundation
import UIKit

typealias JSON = [ String : Any ]

struct CardAPIClient {
    
    //https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1
    
    //https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=2
    
    static let shared = CardAPIClient()
    
    private init() {}
    
    func newDeckShuffled(_ completion: @escaping (String, JSON) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
        let task = session.dataTask(with: url!) { data, response, error in
            
            guard let data = data else { fatalError() }
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! JSON else { return }
            guard let deckID = responseJSON["deck_id"] as? String else { return }
            
            OperationQueue.main.addOperation {
                completion(deckID, responseJSON)
            }
        }
        task.resume()
        
    }
    
    func drawCards(_ deckID: String, numberOfCards count: Int, completion: @escaping (JSON) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=\(count)")
        let task = session.dataTask(with: url!) { data, response, error in
            
            guard let data = data else { fatalError() }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! JSON
            if let json = responseJSON {
                OperationQueue.main.addOperation {
                    completion(json)
                }
            }
        }
        task.resume()
    }
    
    func downloadImage(at url: URL, handler completion: @escaping (Bool, UIImage?) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let imageData = try? Data(contentsOf: url) else { fatalError() }
            OperationQueue.main.addOperation {
                let image = UIImage(data: imageData)
                completion(true,image)
            }
        }
        task.resume()
        
    }
    
}
