//
//  MapView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI
import MapKit

let INIT_LATITUDE_DELTA = 0.01
let INIT_LONGITUDE_DELTA = 0.01

let UEC_LATITUDE = 35.656068
let UEC_LONGITUDE = 139.5440491

var init_latitude = UEC_LATITUDE
var init_longitude = UEC_LONGITUDE


class MapData: ObservableObject {
  @Published var region: MKCoordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: init_latitude, longitude: init_longitude),
    span: MKCoordinateSpan(latitudeDelta: INIT_LATITUDE_DELTA, longitudeDelta: INIT_LONGITUDE_DELTA)
  )
//  @Published var events: [Event] = []
}

//struct MapLocation: Identifiable {
//  let id = UUID()
//  let newMarker: Bool
//  let event: Event
//  let latitude: Double
//  let longitude: Double
//  var coordinate: CLLocationCoordinate2D {
//    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//  }
//}

struct MapView: View {
  @Binding var region: MKCoordinateRegion
  @Binding var events: [Event]
  var eventDetailData: EventDetailData
//  @Binding var showEventDetailModal: Bool
  @EnvironmentObject var eventMapData : EventMapData
  
  var body: some View {
    return Map(
      coordinateRegion: $region,
      interactionModes: MapInteractionModes.all,
      showsUserLocation: true,
      annotationItems: events,
      annotationContent: {
        event in MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
          EventIcon(url: event.organizeUser.imageURL)
           .gesture(
              TapGesture()
                .onEnded({
                  print("tapped")
                  async {
                    eventDetailData.event = event
                    await eventDetailData.fetchEvent(eventID: event.id)
                    eventMapData.showEventDetailModal = true
                  }
                })
           )
       }
     }
    )
    .edgesIgnoringSafeArea(.all)
  }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//      MapView(region: MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: init_latitude, longitude: init_longitude),
//        span: MKCoordinateSpan(latitudeDelta: INIT_LATITUDE_DELTA, longitudeDelta: INIT_LONGITUDE_DELTA)
//      ), MaoLocations: [])
//    }
//}
