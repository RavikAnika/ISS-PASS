//
//  Pass.swift
//  ISS-Passes
//
//  Created by Ravi on 06/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

class Pass:NSObject {
    
    /// ------ Variable Declarations ----
    
   private static var listofPasses = [Pass]()
    var duration: String?
    var riseTime: String?
    static let urlString = "http://api.open-notify.org/iss-pass.json"
    
    
    // ---- Service call to get passes ----------
    
    class  func getAllPasses(Lat:Double, long :Double, completion: @escaping (_ success: Bool?, _ passes:[Pass], _ error: NSError?) -> Void) {
        let url = URL(string:urlString + "?lat=" + "\(Lat)" + "&lon=" + "\(long)")
        if let urlString = url {
            let task = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                if error != nil {
                    print("errror:",error.debugDescription )
                } else {
                    if let responeData = data {
                        let json = try? JSONSerialization.jsonObject(with: responeData, options: []) as? [String: Any]
                        if let dictionary = json as? [String: Any] {
                            if let message = dictionary["message"] as? String {
                                if message == "success" {
                                    if let requestData = dictionary["request"] as? [String: Any] {
                                        let numberofpasses = requestData["passes"] as! Int
                                        if numberofpasses > 0 {
                                            if let responseData = dictionary ["response"] as? [[String: Any]] {
                                                Pass.listofPasses = [Pass]()
                                                for eachpass in responseData {
                                                    let pass = Pass()
                                                    pass.duration = "\(eachpass["duration"] as! Int)"
                                                    pass.riseTime = self.getDateValueFromTimeStamp(timeInterval: eachpass["risetime"] as! Int)
                                                    Pass.listofPasses.append(pass)
                                                }
                                                completion(true, Pass.listofPasses, nil)
                                            }
                                        }
                                    }
                                }
                                else {
                                    completion(false, Pass.listofPasses ,NSError(domain: "Com.Ravi", code: 401, userInfo: nil))
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // Generic function to get the time stamp and return
   class func getDateValueFromTimeStamp(timeInterval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
}

