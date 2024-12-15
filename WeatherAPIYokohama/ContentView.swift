import SwiftUI

/// ## Propaty
/// - id = UUID()
/// - main: Main
/// - weather: [Weather]
/// - pop: Double
/// - wind:Wind
struct WeatherData: Codable {
    struct WeatherD: Codable,Identifiable {
        let id = UUID()
        let main: Main
        let weather: [Weather]
        let pop: Double
        let wind:Wind
    }

    struct Main: Codable {
        let feels_like:Double
        let humidity:Double
    }
    struct Weather: Codable {
        let main:String
        @ViewBuilder var main_result : some View {
            switch self.main {
            case "Clear" :
                Image(systemName: "sun.max")
                    .foregroundStyle(.red)
            case "Clouds":
                Image(systemName: "cloud")
                    .foregroundStyle(.primary)
            case "Rain":
                Image(systemName: "cloud.rain")
                    .foregroundStyle(.blue)
            case "Snow":
                Image(systemName: "snowflake")
                    .foregroundStyle(.cyan)
            default:
                Image(systemName: "questionmark.circle")
            }
        }

    }
    struct Wind : Codable {
        let speed:Double
    }
    let list:[WeatherD]

    struct City:Codable{
        let name:String
    }
    let city:City
}

// MARK: -Content
struct ContentView: View {
    @State private var weather: WeatherData?
    @State private var errorMessage: String?

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment:.center) {
                if let weather = weather {
                    HStack{
                        ForEach(weather.list) { weather in
                            VStack(alignment:.center) {
                                weather.weather.first?.main_result
                            }
                        }
                    }

                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Loading...")
                }
            }
            .padding()
            .onAppear{
                fetchWeather()
            }
        }
        .padding(.vertical, 20)
        .border(.black, width: 1)
    }

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

#Preview {
    ContentView()
}
