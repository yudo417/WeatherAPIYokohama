import SwiftUI

struct WeatherData: Codable {
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
        let description: String
    }
    let weather: [Weather]
    let main: Main
    let name: String
}

struct ContentView: View {
    @State private var weather: WeatherData?
    @State private var errorMessage: String?

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment:.center) {
                if let weather = weather {
                    VStack{
                        Text("\(weather.name)")
                        Text("気温:　\(String(format: "%.1f", weather.main.temp - 273.15))")
                            .font(.title3)
                    }

                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Loading...")
                }
            }
            .onAppear{
                fetchWeather()
            }
        }
        .padding(.vertical, 40)
        .border(.black, width: 1)
    }

    func fetchWeather() {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        let apiKey = "f3406913417c0da6f9176a4b89c1c2be"
        let latitude = 35.473530770162306
        let longitude = 139.58599202401908

        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
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

#Preview {
    ContentView()
}
