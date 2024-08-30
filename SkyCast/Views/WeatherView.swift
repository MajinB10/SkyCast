//
//  WeatherView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    let imageUrls = [
        "https://wallpapersmug.com/download/1024x768/7a22c5/forest_mountains_sunset_cool_weather_minimalism.jpg",
        "https://w0.peakpx.com/wallpaper/947/736/HD-wallpaper-peaceful-lake-minimal-lake-minimalism-minimalist-artist-artwork-digital-art-deviantart.jpg"
    ]
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                    
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }
                        .frame(maxWidth: 150, alignment: .leading)
                        
                        
                        Spacer()
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 90))
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 0)
                    
                    let randomUrlString = imageUrls.randomElement() ?? imageUrls[0]
                    if let randomUrl = URL(string: randomUrlString) {
                        AsyncImage(url: randomUrl) {image in image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                            .cornerRadius(20, corners: .allCorners)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("Image failed to load")
                    }
                    
                    
                    Spacer()
                        
                
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment:.leading)
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Weather now")
                        .bold().padding(.bottom)
                    
                    HStack{
                        WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                    }
                    HStack{
                        WeatherRow(logo: "wind", name: "Wind Speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(.black)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
