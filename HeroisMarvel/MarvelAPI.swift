//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Tiago Xavier da Cunha Almeida on 07/12/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "41150db9eb762b5bb92fff9aaeb7c5b154c17fea"
    static private let publicKey = "e739e0ed558b7175381056f54ddc6470"
    static private let limit = 50
    
    
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void){
        
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredencials()
        
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data ,
                  let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            
            onComplete(marvelInfo)
            
        }
        
    }
    
    
    
    private class func getCredencials() -> String{
        let timeStamp = String(Date().timeIntervalSince1970)
        let hash = MD5(timeStamp + privateKey + publicKey).lowercased()
        return "ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
        
    }
}
