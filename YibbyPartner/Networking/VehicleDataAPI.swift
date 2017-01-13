//
//  VehicleDataAPI.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/10/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import Foundation
import CocoaLumberjack
import Alamofire
import AlamofireObjectMapper

typealias GetMakesCompletionBlock = (_ makes: [VehicleMake]?, _ error: Error?) -> Void
typealias GetModelsCompletionBlock = (_ makes: [VehicleModel]?, _ error: Error?) -> Void

class VehicleDataAPI: NSObject {
    
    // MARK: - Properties
    
    let BASE_URL = "http://www.carqueryapi.com/api/0.3"
    let GET_MAKES_URL = "/?cmd=getMakes&sold_in_us=1"
    let GET_MODELS_URL = "/?cmd=getModels&sold_in_us=1"
    
    var baseURL: URL!
    
    static var sharedClient = VehicleDataAPI(baseURL: nil)
    
    init(baseURL: String?) {
        self.baseURL = URL(string: BASE_URL)
        super.init()
    }

    func getMakes(forYear year: String, completion: @escaping GetMakesCompletionBlock) {
        
        let path = GET_MAKES_URL + "&year=\(year)"
        let url = baseURL.absoluteString + path
        
        Alamofire.request(url).responseObject(completionHandler: { (response: DataResponse<VehicleMakes>) in
 
            let vehicleMakes = response.result.value
            
            if (response.result.isFailure) {
                completion(nil, response.result.error)
            } else {
                completion(vehicleMakes?.makes, nil)
            }
        })
    }
    
    func getModels(forMakeAndYear make: String, year: String, completion: @escaping GetModelsCompletionBlock) {
        
        let path = GET_MODELS_URL + "&make=\(make)" + "&year=\(year)"
        let url = baseURL.absoluteString + path
        
        Alamofire.request(url).responseObject(completionHandler: { (response: DataResponse<VehicleModels>) in
            
            let vehicleModels = response.result.value
            
            if (response.result.isFailure) {
                completion(nil, response.result.error)
            } else {
                completion(vehicleModels?.models, nil)
            }
        })
    }
}
