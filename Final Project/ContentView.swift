//
//  ContentView.swift
//  Final Project
//
//  Created by Tran Nguyen on 4/15/25.
//

import SwiftUI
import OpenMeteoSdk

struct WeatherData : Codable{
    let current: Current
    let daily: Daily

    struct Current : Codable {
        let time: Date
        let temperature2m: Float
        let relativeHumidity2m: Float
        let precipitation: Float
    }
    struct Daily : Codable {
        let time: [Date]
        let uvIndexMax: [Float]
    }
}

struct WeatherCondition: Codable {
    let weatherText: String

    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
    }
}


struct ContentView: View {
    @State private var tasks = [Task]()
    @State private var newTaskItem = ""
    @State private var isShowingItemCreation = false
    @State private var log = ""
    @State private var hoursSlept = 8
    @State var weatherInfo: WeatherData? = nil
    @State var weatherCondition: WeatherCondition? = nil

    var body: some View {
        TabView{
            VStack {
                HStack{
                    Text("Tasks")
                        .padding(.horizontal)
                        .font(.title)
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            isShowingItemCreation = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 30))
                            
                        }
                        .padding(.horizontal, 30)
                    }
                }
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach($tasks) { $task in
                            TaskView(isDone: $task.isDone, taskItem: task.item)
                        }
                    }
                    .padding()
                }
                ScrollView{
                    
                    
                    HStack{
                        Text("Hours Slept")
                            .padding(.horizontal)
                            .font(.title)
                        Spacer()
                    }
                    
                    
                    
                    
                    HStack {
                        Button{
                            if hoursSlept > 0 {
                                hoursSlept -= 1
                            }
                        }label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.largeTitle)
                        }
                        
                        Text("\(hoursSlept) hours")
                            .font(.title)
                            .padding(.horizontal, 20)
                        
                        Button{
                            if hoursSlept < 24 {
                                hoursSlept += 1
                            }
                        }label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                    
                    
                    
                    HStack{
                        Text("Log")
                            .padding(.horizontal)
                            .font(.title)
                        
                        Spacer()
                    }
                    ScrollView{
                        TextEditor(text: $log)
                            .padding()
                            .frame(height:150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        
                        
                    }
                    HStack{
                        Text("Weather Data")
                            .padding(.horizontal)
                            .font(.title)
                        
                        Spacer()
                    }
                    
                    if let weatherInfo = weatherInfo {
                        VStack {
                            if let weatherCondition = weatherCondition {
                                Text("Weather: \(weatherCondition.weatherText)")
                            } else {
                                Text("Loading Weather Description...")
                            }
                            Text("Temperature: \(weatherInfo.current.temperature2m)°F")
                            Text("Humidity: \(weatherInfo.current.relativeHumidity2m)%")
                            Text("Precipitation: \(weatherInfo.current.precipitation) in")
                            Text("UV Index Max: \(weatherInfo.daily.uvIndexMax.first ?? 0)")
                            
                        }
                        .padding()
                        .frame(alignment: .leading)
                    } else {
                        Text("Loading weather data...")
                    }
                }
                Spacer()
            }
            .task{
                await getData()
            }
            .sheet(isPresented: $isShowingItemCreation) {
                ItemCreationView(task: $newTaskItem) {
                    if !newTaskItem.isEmpty {
                        tasks.append(Task(item: newTaskItem, isDone: false))
                        newTaskItem = ""
                    }
                    isShowingItemCreation = false
                }
            }
            .tabItem{
                Image(systemName: "house.fill")
                Text("Home")
    
            }
            VStack{
                HStack{
                    Text("Routines")
                        .padding(.horizontal)
                        .font(.title)
                    
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                        .padding(.horizontal, 30)
                }
                Spacer()
            }
            .tabItem{
                Image(systemName: "calendar.day.timeline.left")
                Text("Routines")
            }
            VStack{
                HStack{
                    Text("Progress")
                        .padding(.horizontal)
                        .font(.title)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                        .padding(.horizontal, 30)
                    
                }
                TabView {
                    Image("wound_before")
                        .resizable()
                        .scaledToFill()
                    
                    Image("wound_after")
                        .resizable()
                        .scaledToFill()
                    
    
                }
                .tabViewStyle(.page)
                .frame(height: 300)
                TabView {
                    Image("wound_before")
                        .resizable()
                        .scaledToFill()
                    
                    Image("wound_after")
                        .resizable()
                        .scaledToFill()
                    
    
                }
                .tabViewStyle(.page)
                .frame(height: 300)
                Spacer()
            }
            .tabItem{
                Image(systemName: "book.fill")
                Text("Progress")
            }
            VStack{
                HStack{
                    Text("Insights")
                        .padding(.horizontal)
                        .font(.title)
                    Spacer()
                }
                HStack{
                    Text("This Month")
                }
                VStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<7, id: \.self) { column in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray)
                                    .frame(width: 40, height: 40)
                                    
                            }
                        }
                    }
                }
            
                
                Spacer()
            }
            .tabItem{
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Insights")
            }
            VStack{
                HStack{
                    Text("Treatments")
                        .padding(.horizontal)
                        .font(.title)
                    
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                        .padding(.horizontal, 30)
                }
                Spacer()
            }
            .tabItem{
                Image(systemName: "pills.fill")
                Text("Treatments")
            }
        }
    }
    
    private func getData() async {
        do {
            let result = try await WeatherService.getWeatherInfo()
            weatherInfo = result
        } catch {
            print(error)
        }
        do {
                let conditionResult = try await WeatherService.getCurrentConditions()
                weatherCondition = conditionResult
        } catch {
            print(error)
        }
    }
}

class WeatherService {
    static func getWeatherInfo() async throws -> WeatherData {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=35.9132&longitude=-79.0558&daily=uv_index_max&current=temperature_2m,relative_humidity_2m,precipitation&past_days=1&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch&format=flatbuffers")!
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        let response = responses[0]

        let utcOffsetSeconds = response.utcOffsetSeconds
        let current = response.current!
        let daily = response.daily!

        let weatherData = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                relativeHumidity2m: current.variables(at: 1)!.value,
                precipitation: current.variables(at: 2)!.value
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                uvIndexMax: daily.variables(at: 0)!.values
            )
        )

        return weatherData
    }
    static func getCurrentConditions() async throws -> WeatherCondition {
        let url = URL(string: "https://dataservice.accuweather.com/currentconditions/v1/2109539?apikey=HMHLzOziS4TfMQQyvAGzqqKQl4A17qXw")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let conditions = try JSONDecoder().decode([WeatherCondition].self, from: data)
        return conditions[0]
    }
    
}
#Preview {
    ContentView()
}
