//
//  NetworkManager.swift
//  GCD_Group
//
//  Created by Amit Chowdhury on 6/24/21.
//

import Foundation

class NetworkManager {
    
    func fetchNetworkData(_ url:String, completion:@escaping(Data)->Void){
        guard let url = URL(string: url) else {
            return
        }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if error == nil {
                guard let safeData = data else {
                    return
                }
                completion(safeData)
            }
        }
        task.resume()
        debugPrint(url)
    }
    
    func fetchPostsData (_ url:String, completion:@escaping ([Post])->Void){
        
        fetchNetworkData(url) { (safeData) in
            let jsonDecoder = JSONDecoder()
            do{
                let results = try jsonDecoder.decode([Post].self, from: safeData)
                completion(results)
            }catch{
                return
            }
        }
    }
    
    func fetchCommentsData (_ url:String, completion:@escaping ([Comment])->Void){
        
        fetchNetworkData(url) { (safeData) in
            let jsonDecoder = JSONDecoder()
            do{
                let results = try jsonDecoder.decode([Comment].self, from: safeData)
                completion(results)
            }catch{
                return
            }
        }
    }
}
