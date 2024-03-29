//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let API_KEY = "ZjQ4NmRjZDYxMWM5NDVhM2EyZTFjYmY2YWM5NDQ3ZDE"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var pickedCurrency : String = ""
    
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var todayChangeLabel: UILabel!
    @IBOutlet weak var yearChangeLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCurrency = currencySymbolArray[row]
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL)
    }

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
                if response.result.isSuccess {
                    print("Data recieved")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(json: bitcoinJSON)

                }
                else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinPriceResult = json["last"].double {
            print(json)
            var symbol : String = ""
            bitcoinPriceLabel.text = "\(pickedCurrency)\(bitcoinPriceResult)"
            let todayChangePercentage = json["changes"]["percent"]["day"].doubleValue
            if todayChangePercentage > 0 {
                symbol = "+"
            }
            else if todayChangePercentage <= 0 {
                symbol = ""
            }
            todayChangeLabel.text = "Today: \(symbol)\(todayChangePercentage)%"
            let yearChangePercentage = json["changes"]["percent"]["year"].doubleValue
            yearChangeLabel.text = "This year: \(symbol)\(yearChangePercentage)%"
            
        }
        else {
            bitcoinPriceLabel.text = "No data recieved"
        }
        
    }
//




}

