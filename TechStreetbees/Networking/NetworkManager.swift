//
//  NetworkManager.swift
//  TechStreetbees
//
//  Created by Maxence de Cussac on 03/09/2018.
//  Copyright © 2018 Maxence de Cussac. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    var configuration = Configuration()

    static let shared = NetworkManager()
    
    // MARK: - Private methods
    func retrieveComicsData(completion: @escaping (_ comics: [Comic]) -> Void) {
        let currentTimestamp = Date.timeIntervalSinceReferenceDate

        let stringForMD5 = String(currentTimestamp) + configuration.environment.marvelPrivateKey + configuration.environment.marvelPublicKey
        let hash = stringForMD5.md5()

        let params = [
            "ts": currentTimestamp,
            "apikey": configuration.environment.marvelPublicKey,
            "hash": hash
            ] as [String : Any]
        let urlString = configuration.environment.marverComicsURL// + "&ts=\(currentTimestamp)&apikey=\(configuration.environment.marvelPublicKey)&hash=\(hash)"

        Alamofire.request(urlString, parameters: params).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    print("success")
                default:
                    print("error with status : \(status)")
                }
            }

            if let result = response.result.value {
                guard let json = result as? NSDictionary else {
                    return
                }
                if let data = json["data"] as? NSDictionary {
                    let results = data["results"] as! [NSDictionary]
                    var comics = [Comic]()
                    for item in results {
                        let comic = Comic(withDictionary: item)
                        comics.append(comic)
                    }
                    completion(comics)
                }
            }
        }
    }
}
