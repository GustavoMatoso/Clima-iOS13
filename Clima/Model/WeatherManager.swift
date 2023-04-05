//
//  WeatherManager.swift
//  Clima
//
//  Created by Gustavo Matoso on 04/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager{
    var temperaturex = 0.0
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=44485b2c2e23c5a4cc4e6ce8f4b734cc&units=metric&"
    
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
                    parseJSON(weatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do  {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = (decodedData.main.temp)
           // temperaturex = temperature
            let id = (decodedData.weather[0].id)
            //print(getConditionName(conditionID: id))
        } catch {
            print(error)
        }
    }
    
    func getConditionName(conditionID: Int)-> String{
        switch conditionID {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }

    }
//    func getTemperature()->String{
//
//        return String(temperaturex)
//
//    }
}




