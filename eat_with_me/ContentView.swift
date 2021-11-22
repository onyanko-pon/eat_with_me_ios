//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI
import MapKit

var sampleUser = User(
  id: 1,
  username: "username",
  imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png"
)

struct ContentView: View {
  @ObservedObject var mapData = MapData()
  @ObservedObject var eventObservable = EventObserable()
  @ObservedObject var eventsData = EventsData(userID: 2)
  
  @State var isShowHalfModal = false
  @State var showEventDetailModal = false
  
  @ObservedObject var userdata = UserData(userID: 2)
  @ObservedObject var eventDetailData = EventDetailData(userID: 2)

  var body: some View {

    NavigationView {
      ZStack {
        MapView(region: $mapData.region, events: $eventsData.events, eventDetailData: eventDetailData, showEventDetailModal: $showEventDetailModal)
        .onAppear {
          print("Map　表示された！")
        }
        
        VStack() {
          
          HStack () {
            Spacer()
            NavigationLink(destination: UserListView()) {
              if userdata.user != nil,
                 let imageURL = userdata.user?.imageURL {
                UserIcon(url: imageURL, size: 55.0)
              }
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
      .sheet(isPresented: $isShowHalfModal) {
        VStack () {
          EventModalView(
            title: $eventObservable.title,
            description: $eventObservable.description,
            startDatetime: $eventObservable.startDatetime,
            endDatetime: $eventObservable.endDatetime,
            action: {
              isShowHalfModal.toggle()

              let event = Event(
                id: 1,
                title: eventObservable.title,
                description: eventObservable.description,
                startDatetime: eventObservable.startDatetime,
                endDatetime: eventObservable.startDatetime,
                latitude: self.mapData.region.center.latitude,
                longitude: self.mapData.region.center.longitude,
                imageURL: "https://pics.prcm.jp/e3d9c42a77b3f/84581569/jpeg/84581569.jpeg",
                organizeUser: sampleUser,
                participants: []
              )
              self.eventsData.addEvent(event: event)
//              self.eventsData.events.append(event)

              // reset observable
              self.eventObservable.reset()
              
          })
          Spacer()
        }
      }
      
      .sheet(isPresented: $showEventDetailModal) {
        VStack () {
          EventDetailModal(eventDetailData: eventDetailData)
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
