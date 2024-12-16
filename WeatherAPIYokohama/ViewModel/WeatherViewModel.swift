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
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = "f3406913417c0da6f9176a4b89c1c2be"
        let city = "Yokohama"

        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey)
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
