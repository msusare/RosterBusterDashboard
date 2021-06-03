//
//  APIManager.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 29/05/21.
//

import Foundation

struct APIManager {
    
    static func readDataFromBaseUrl(url: URL?, completionHandler: @escaping (RosterStory?, URLResponse?, Error?) -> Void) {
        
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.rosterStoryTask(with: url) { rosterStoryElement, response, error in
            
            completionHandler(rosterStoryElement, response, error)
        }
        task.resume()
    }
}
