//
//  WeatherManager.swift
//  Clima
//
//  Created by Gustavo Matoso on 04/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=44485b2c2e23c5a4cc4e6ce8f4b734cc&units=metric&"
    
    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String){
        
        let urlString = "\(weatherURL)q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func featchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    // func Realizar Requisição
    func performRequest(with urlString: String){
        // 1. Create a URL
        
        if let url = URL(string: urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                         delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do  {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decodedData.main.temp
            let id = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temperature)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    

}




