//
//  APIManager.swift
//  MyGlamm
//
//  Created by C711091 on 12/12/19.
//  Copyright © 2019 icici. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager: NSObject {
    
    var delegate:tableDataUpdate?
    
    let url = "https://developers.zomato.com/api/v2.1/search?"
    
    let API_KEY="b19027f91aba38345fb235843b9064d4"
    
    var cityName=""
    
    var resturantData:[ResturantDataModel]=[]
    
    
    override init() {
        super.init()
       
    }
    func datafetch(text:String){
        print("test\(text)")
        
        let resourceString = url+"entity_type=\(text)"
        let escapedAddress = resourceString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        let urlz=URL(string: escapedAddress!)
        print("URL\(urlz)")
        
        var urlRequest = URLRequest(url: urlz!)     // issue wirh space between two string
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(API_KEY, forHTTPHeaderField: "user-key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.resturantData.removeAll()
        let session = URLSession.shared
        
        print("URL String\(resourceString)")
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
         
            if  data == nil
            {
                DispatchQueue.main.async {
                    
                    self.delegate?.loadData(arrData: self.resturantData,alertflag: true)
                }
            
            }
            else{
            print(data!)
            
            let json =  try? JSON(data: data!)
            
            print(" \(json!["restaurants"].count)")
                
            for i in 0..<json!["restaurants"].count
            {
                var resName = json!["restaurants"][i]["restaurant"]["name"].string
                
                var resthumbUrl = json!["restaurants"][i]["restaurant"]["thumb"].string
                
                var resRatingText = json!["restaurants"][i]["restaurant"]["user_rating"]["rating_text"].string
                
                var resAggregate_rating = json!["restaurants"][i]["restaurant"]["user_rating"]["aggregate_rating"].string
                
                
                if let resNamTmp = resName{
                    resName = resNamTmp
                }else{
                    resName = ""
                }
                if let resRatingTmp = resRatingText{
                    resRatingText = resRatingTmp
                }else{
                    resRatingText = ""
                }
                if let resAggRatingTmp = resAggregate_rating{
                    resAggregate_rating = resAggRatingTmp
                }else{
                    resAggregate_rating = ""
                }
                if let resRatingTmp = resthumbUrl{
                    resthumbUrl = resRatingTmp
                }else{
                    resthumbUrl = ""
                }
                
                
                let resData =  ResturantDataModel.init(name: resName!, aggregate_rating: resAggregate_rating!, rating_text: resRatingText!, thumb: resthumbUrl!)
                
                self.resturantData.append(resData)
                print(self.resturantData[i])
                // Do this
            }
            DispatchQueue.main.async {
                
            self.delegate?.loadData(arrData: self.resturantData,alertflag: false)
            }
            }

            
        })
        task.resume()
    }
    
    
    

    
}
