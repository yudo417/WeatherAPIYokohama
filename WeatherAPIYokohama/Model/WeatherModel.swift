//
//  WeatherModel.swift
//  WeatherAPIYokohama
//
//  Created by 林　一貴 on 2024/12/16.
//

import Foundation
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
        let dt_txt:String
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
