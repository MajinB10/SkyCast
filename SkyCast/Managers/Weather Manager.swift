//
//  Weather Manager.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("6069ace172d77cfc048a14d0686937e6")&units=metric") else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url:url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}

func getCoordinates(for country: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(country) { (placemarks, error) in
        if let error = error {
            // Handle error (e.g., country not found, network issue)
            print("Error occurred while geocoding: \(error.localizedDescription)")
            completion(nil, error)
            return
        }
        
        guard let placemark = placemarks?.first,
              let location = placemark.location else {
            // Handle case where no placemark is found
            print("No location found for the given country.")
            completion(nil, nil)
            return
        }
        
        // Extract the coordinates from the location
        let coordinates = location.coordinate
        completion(coordinates, nil)
    }
}


// Model of the response body we get from calling the OpenWeather API
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
