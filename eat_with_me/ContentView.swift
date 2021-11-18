//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @ObservedObject var mapData = MapData()
  @ObservedObject var eventObservable = EventObserable()
  
  @State var isShowHalfModal = false

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
          title: $eventObservable.title,
          description: $eventObservable.description,
          date: $eventObservable.date,
          action: {
            isShowHalfModal.toggle()

            let event = Event(
              title: eventObservable.title,
              description: eventObservable.description,
              date: eventObservable.date,
              latitude: self.mapData.region.center.latitude,
              longitude: self.mapData.region.center.longitude,
              imageURL: "https://pics.prcm.jp/e3d9c42a77b3f/84581569/jpeg/84581569.jpeg"
            )
            let location = MapLocation(newMarker: false, event: event, latitude: event.latitude, longitude: event.longitude)
            self.mapData.append(obj: location)
            
            // reset observable
            self.eventObservable.title = ""
            self.eventObservable.description = ""
            self.eventObservable.date = Date()
            
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
