//
//  ViewController.swift
//  Geo Location
//
//  Created by Vj Ay on 26/04/19.
//  Copyright © 2019 Vj Ay. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate{

    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "334212426a71c6577f598e4baaedf444"

    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var tempStatus: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }


    @IBAction func getWeather(_ sender: Any) {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
         print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]

            getWeatherData(url: WEATHER_URL, parameters: params)
            
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        label.text = "Location Unavailable"
        
        print("error")
    }
    
    
    
    
    func getWeatherData(url : String, parameters : [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                print("Success Got the weather Data")
      
                let weatherJSON : JSON = JSON(response.result.value!)
                
             
                self.updateWeatherData(json: weatherJSON)
        
                
            }
            else {
                
                print("Error \(response.result.error)")
                self.label.text = "Connection Issue"
            }
            
        }
    }
    
    
    
//    JSON Parsing
    
    func updateWeatherData(json : JSON) {
        
          let tempResult = json["main"]["temp"].double
        
            weatherDataModel.temperature = Int(tempResult! - 273.15)
        
           weatherDataModel.city = json["name"].stringValue
        
            weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        let cityResult = json["json"]["name"]
        
        
      updateWeatherIcon()
        
   
        
    }
    
    func updateWeatherIcon() {
        
        label.text = weatherDataModel.city
        
        print(weatherDataModel.city)
        
        temp.text = String(weatherDataModel.temperature) + "°"
        
        tempStatus.text = weatherDataModel.weatherIconName
        
        imageView.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    func userEnteredNewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            
            
        }
    }
}

