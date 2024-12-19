import SwiftUI
import Algorithms



// MARK: -Content
struct ContentView: View {
    @ObservedObject var wvm = WeatherViewModel()


    var body: some View {
        NavigationStack {
            ScrollView(.horizontal,showsIndicators: false) {
                VStack(alignment:.center) {
                    element
                }
                .padding()
                .onAppear{
                    wvm.fetchWeather()
                }
            }
            .padding(.vertical, 10)
            .padding(.leading,20)
            .border(.black, width: 1)
            .navigationTitle("天気")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        wvm.fetchWeather()
                    } label: {
                        Image(systemName: "clock.arrow.2.circlepath").font(.title)
                    }

                }
            }
        }
    }


}

#Preview {
    ContentView()
}


extension ContentView{
    func CaltempC(_ temp:Double) -> String{
        String(format:"%.1f",temp)
    }

    func CalTime(_ time:String) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "ja_JP")
        let dataString = df.date(from: time)!
        df.dateFormat = "HH : mm"
        return df.string(from: dataString)
    }

    func CalDay(_ time:String,isFirst:Bool = false) -> String{
        let isFirst = isFirst
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "ja_JP")
        let dataString = df.date(from: time)!
//        let _ = print("a:\(dataString)")
        df.dateFormat = "HH"
        let dftime = df.string(from: dataString)
        df.dateFormat = "MM/dd(EEEEE)"
        if isFirst{ return df.string(from: dataString) }
        return dftime == "00" ? df.string(from: dataString) : ""
    }

    func isAfter (_ time : String) -> Bool{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "ja_JP")
        let dataString = df.date(from: time)!
        return (Date() < dataString) ? true : false
    }
}

extension ContentView{
    private var element: some View{
        Group{
            if let weather = wvm.weather {
                HStack{
                    ForEach(weather.list.indexed(),id:\.0) {index,  weather in
                        VStack(alignment:.center,spacing:10) {
                            if index == 0 {
                                Text("\(CalDay(weather.dt_txt,isFirst:true))")
                            }else{
                                Text("\(CalDay(weather.dt_txt))")
                            }
                            Text("\(CalTime(weather.dt_txt))")
                            weather.weather.first?.main_result
                                .frame(width: 20, height: 30)
                            Text("\(CaltempC(weather.main.feels_like))℃")
                            Text("\(String(format:"%.0f",weather.pop))")
                                .foregroundStyle(.blue)

                        }
                        .fontWeight(.bold)
                        .padding(.horizontal,3)
                        .opacity(isAfter(weather.dt_txt) ? 1 : 0.3)
                    }
                }

            } else if let errorMessage = wvm.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Loading...")
            }
        }
    }
}
