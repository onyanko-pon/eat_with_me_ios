//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI
import MapKit

var sampleUser = User(
  username: "username",
  imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png"
)

struct ContentView: View {
  @ObservedObject var mapData = MapData()
  @ObservedObject var eventObservable = EventObserable()
  
  @State var isShowHalfModal = false
  @State var showEventDetailModal = false
  
  @State var detailEvent = Event(
    title: "",
    description: "",
    date: Date(),
    latitude: 0.0,
    longitude: 0.0,
    imageURL: "",
    participants: []
  )

  var body: some View {

    NavigationView {
      ZStack {
        MapView(region: $mapData.region, MapLocations: $mapData.MapLocations, detailEvent: $detailEvent, showEventDetailModal: $showEventDetailModal)
        .onAppear {
          print("Map　表示された！")
        }
        
        VStack() {
          
          HStack () {
            Spacer()
            NavigationLink(destination: UserList()) {
              UserIcon(url: user.imageURL, size: 55.0)
            }
            Spacer()
              .frame(width: 25)
          }
          
          Spacer()
          CreateEventButton(action: {
            print("ボタンが押された")
            isShowHalfModal.toggle()
          })
          
          Spacer()
            .frame(height: 25)
        }
      }
      .navigationBarHidden(true)
      .navigationBarTitleDisplayMode(.inline)
//    .navigationBarTitleDisplayMode(.inline)
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
                imageURL: "https://pics.prcm.jp/e3d9c42a77b3f/84581569/jpeg/84581569.jpeg",
                participants: [sampleUser, sampleUser, sampleUser, sampleUser, sampleUser, sampleUser, sampleUser]
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
      
      .sheet(isPresented: $showEventDetailModal) {
        VStack () {
          EventDetailModal(event: $detailEvent)
          Spacer()
        }
      }
      
    }
    
    
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
