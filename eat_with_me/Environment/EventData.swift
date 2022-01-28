//
//  EventData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2022/01/26.
//

import Foundation
import SwiftUI
class EventMapData: ObservableObject {
  @Published var showEventEditModal = false
  @Published var showEventDetailModal = false
  
  @Published var editEventID: Int? = nil
  
  @Published var eventObservable = EventObserable()
  
  @Published var latitude: Double = 0.0
  @Published var longitude: Double = 0.0
  @Published var organizeUser: User? = nil
  
  @EnvironmentObject var appData: AppData
  
  
  public func setEventObservable(event: Event) {
    self.eventObservable.id = event.id
    self.eventObservable.description = event.description
    self.eventObservable.title = event.title
    self.eventObservable.startDatetime = event.startDatetime
    self.eventObservable.endDatetime = event.endDatetime
    
    self.latitude = event.latitude
    self.longitude = event.longitude
    self.organizeUser = event.organizeUser
  }
  
}
