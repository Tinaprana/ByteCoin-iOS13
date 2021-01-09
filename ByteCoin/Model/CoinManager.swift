//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinManagerDelegate {
    func didUpdateCurrency(currency: Double)
    func didFailWithError(error:Error)
}

struct CoinManager {
 var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9C7BB222-6395-4AD3-82D9-4EDB233EFE64"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let URLString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
       

        performRequest(URLString: URLString)
    }
   
      func performRequest(URLString:String)  {
          //        now we do the 4 steps of networking in swift
          //       1. cearte URL
          if let url = URL(string: URLString){
              
              //       2.create a URLSession
              let session = URLSession(configuration: .default)
              
              //        3. give the session a task
              
              let task = session.dataTask(with: url) { (data, response, error) in
                  if error != nil {
                    
                    self.delegate?.didFailWithError(error:error!)
                      return
                  }
                  if let safeData = data {
                    if let currency =  self.parseJSON(data: safeData){
                        self.delegate?.didUpdateCurrency(currency: currency)
                      }
                      
                  }
              }
              
              //        4.start the task
              task.resume()
          }
      }
     func parseJSON(data: Data)->Double? {
         let decoder = JSONDecoder()
         do {
            let decodeData =  try decoder.decode(CurrencyData.self, from: data)
            
             let rate = decodeData.rate
           
             return rate
            
         } catch {
           
            delegate?.didFailWithError(error:error)
             return nil
         }
     }
}
