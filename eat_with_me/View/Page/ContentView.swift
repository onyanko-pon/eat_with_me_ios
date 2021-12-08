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
  
  init(userID: Int) {
    self.userID = userID
    
    self.mapData = MapData()
    self.eventObservable = EventObserable()
    
    self.eventsData = EventsData(userID: userID)
    self.eventDetailData = EventDetailData(userID: userID)
    
    print(userID)
  }
  
  var userID: Int
  @EnvironmentObject var appData: AppData
  
  @ObservedObject var mapData: MapData
  @ObservedObject var eventObservable: EventObserable
  @ObservedObject var eventsData: EventsData
  
  @ObservedObject var eventDetailData: EventDetailData
 //  @ObservedObject var friendsData: FriendsData
  
  @State var isShowHalfModal = false
  @State var showEventDetailModal = false
  
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
            NavigationLink(destination:
              FriendListView(userID: self.appData.userID)
            ) {
              if appData.friendList.filterAccepted().count == 0 {
                UserIcon(url: "https://cdn.icon-icons.com/icons2/2066/PNG/512/user_icon_125113.png", size: 55.0)
              } else {
                UserIcon(url: appData.friendList.filterAccepted()[0].user.imageURL, size: 55.0)
              }
            }
            NavigationLink(destination: UserDetailView(user: $appData.user)) {
              if appData.user != nil,
                 let imageURL = appData.user?.imageURL {
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
                id: 0,
                title: eventObservable.title,
                description: eventObservable.description,
                startDatetime: eventObservable.startDatetime,
                endDatetime: eventObservable.endDatetime,
                latitude: self.mapData.region.center.latitude,
                longitude: self.mapData.region.center.longitude,
                organizeUser: sampleUser,
                joinUsers: []
              )
              async {
                await self.eventsData.addEvent(event: event)
              }
              self.eventObservable.reset()
              
          })
          Spacer()
        }
      }
      
      .sheet(isPresented: $showEventDetailModal) {
        VStack () {
          EventDetailModal(userID: self.appData.userID, eventDetailData: eventDetailData)
          Spacer()
        }
      }
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userID: 2)
          .previewInterfaceOrientation(.portrait)
    }
}
