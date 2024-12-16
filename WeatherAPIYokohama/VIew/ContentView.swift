import SwiftUI



// MARK: -Content
struct ContentView: View {
    @ObservedObject var wvm = WeatherViewModel()


    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            VStack(alignment:.center) {
                if let weather = wvm.weather {
                    HStack{
                        ForEach(weather.list) { weather in
                            VStack(alignment:.center,spacing:10) {
                                Text("\(CalTime(weather.dt_txt))")
                                weather.weather.first?.main_result
                                Text("\(CaltempC(weather.main.feels_like))")

                            }
                            .padding()
                        }
                    }

                } else if let errorMessage = wvm.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Loading...")
                }
            }
            .padding()
            .onAppear{
                wvm.fetchWeather()
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
    func CaltempC(_ temp:Double) -> String{
        String(format:"%.1f",temp - 273.15)
    }

    func CalTime(_ time:String) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dataString = df.date(from: time)!
        df.dateFormat = "HH:mm"
        return df.string(from: dataString)
    }
}
