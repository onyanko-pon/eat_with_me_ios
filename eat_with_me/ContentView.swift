//
//  ContentView.swift
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

struct MapLocation: Identifiable {
  let id = UUID()
  let name: String
  let latitude: Double
  let longitude: Double
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

let MapLocations = [
  MapLocation(name: "UEC", latitude: UEC_LATITUDE, longitude: UEC_LONGITUDE)
]

struct ContentView: View {
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: init_latitude, longitude: init_longitude),
    span: MKCoordinateSpan(latitudeDelta: INIT_LATITUDE_DELTA, longitudeDelta: INIT_LONGITUDE_DELTA)
  )
   var body: some View {
       Map(
        coordinateRegion: $region,
        interactionModes: MapInteractionModes.all,
        showsUserLocation: true,
        annotationItems: MapLocations,
//        annotationContent: { location in
//          MapMarker(coordinate: location.coordinate, tint: .red)
//        }
        annotationContent: {
          n in MapAnnotation(coordinate: n.coordinate) {
            Circle()
            .fill(Color.green)
            .frame(width: 44, height: 44)
            .onTapGesture(count: 1, perform: {
              print("IT WORKS")
            })
          }
        }
       )
      .edgesIgnoringSafeArea(.all)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
