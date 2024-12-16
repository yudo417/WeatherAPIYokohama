import SwiftUI



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


}

#Preview {
    ContentView()
}


extension ContentView{
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
