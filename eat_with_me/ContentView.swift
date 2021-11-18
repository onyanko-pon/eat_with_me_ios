//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI
import MapKit

struct Event: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let date: Date
  let latitude: Double
  let longitude: Double
}

struct ContentView: View {
  @ObservedObject var mapData = MapData()
  @State var isShowHalfModal = false
  @State var title = ""
  @State var description = ""
  @State var date = Date()

  var body: some View {

    ZStack {
      MapView(region: $mapData.region, MapLocations: $mapData.MapLocations)
      .onAppear {
        print("Map　表示された！")
      }
      
      VStack() {
        Button(action: {
          print("ボタンが押された")
          isShowHalfModal.toggle()
        }){
          Text("この辺でごはんをセッティングする")
            .padding()
            .frame(height: 40)
            .background(Color.white)
        }
//        Spacer().frame(width: 50, height: 100)
      }
    }
    
    .sheet(isPresented: $isShowHalfModal) {
      VStack () {
        EventModalView(
          title: self.$title,
          description: self.$description,
          date: self.$date,
          action: {
            isShowHalfModal.toggle()
            print(self.title, self.description, self.date)
            
            print(self.mapData.region.center)
            let event = Event(
              title: self.title,
              description: self.description,
              date: self.date,
              latitude: self.mapData.region.center.latitude,
              longitude: self.mapData.region.center.longitude
            )
            let location = MapLocation(newMarker: false, event: event, latitude: event.latitude, longitude: event.longitude)
            self.mapData.append(obj: location)
            
            self.title = ""
            self.description = ""
            self.date = Date()
            
            
            
//          print(self.title)
        })
        Spacer()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
