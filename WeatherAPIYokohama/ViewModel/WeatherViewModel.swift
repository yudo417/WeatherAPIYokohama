//
//  WeatherViewModel.swift
//  WeatherAPIYokohama
//
//  Created by 林　一貴 on 2024/12/16.
//

import Foundation

class WeatherViewModel:ObservableObject {
    @Published var weather: WeatherData?
    @Published var errorMessage: String?

    func fetchWeather() {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
         let plistData = NSDictionary(contentsOfFile: path),
         let apiKey = plistData["apiKey"] as? String
        else {
            print("Failed to load API key from con.plist")
            return
        }
        print("取得APIKey:\(apiKey)")
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let city = "Kikuna"

        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components.url else {
            self.errorMessage = "無効なURL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "通信エラー: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "データがありません"
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weather = decodedData
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "デコードエラー: \(error.localizedDescription)"
                }
            }
        }
        .resume()
    }
}
