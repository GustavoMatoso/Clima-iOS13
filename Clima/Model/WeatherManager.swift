//
//  WeatherManager.swift
//  Clima
//
//  Created by Gustavo Matoso on 04/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=44485b2c2e23c5a4cc4e6ce8f4b734cc&units=metric&"
    
    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String){
        
        let urlString = "\(weatherURL)q=\(cityName)"
        performRequest(urlString: urlString)
    }
    // func Realizar Requisição
    func performRequest(urlString: String){
        // 1. Create a URL
        
        if let url = URL(string: urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                }
                if let safeData = data{
                    if let weather = parseJSON(weatherData: safeData){
                         delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do  {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decodedData.main.temp
            let id = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temperature)
            return weather
            
        } catch {
            print(error)
            return nil
        }
    }
    
    

}




