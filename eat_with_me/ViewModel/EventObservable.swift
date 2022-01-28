//
//  EventObservable.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

class EventObserable: ObservableObject {
  @Published var id = 1
  @Published var title = ""
  @Published var description = ""
  @Published var startDatetime = Date()
  @Published var endDatetime = Date()
  
  func reset() {
    self.id = 1
    self.title = ""
    self.description = ""
    self.startDatetime = Date()
    self.endDatetime = Date()
  }
  
  public func getEvent(latitude: Double, longitude: Double, organizeUser: User) -> Event {
    let event = Event(
      id: self.id,
      title: self.title,
      description: self.description,
      startDatetime: self.startDatetime,
      endDatetime: self.endDatetime,
      latitude: latitude,
      longitude: longitude,
      organizeUser: organizeUser,
      joinUsers: []
    )
    
    return event
  }
}
