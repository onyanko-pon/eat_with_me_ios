//
//  EventDetailData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/21.
//

import Foundation
import CloudKit

class EventDetailData: ObservableObject {

  @Published var event: Event? = nil
  let userID: Int
  var eventRepository: EventAPIRepository
  init(userID: Int) {
    self.userID = userID
    self.eventRepository = EventAPIRepository()
  }
  
  func fetchEvent(eventID: Int) async {
    self.event = await self.eventRepository.fetchEvent(eventID: Int64(eventID))
  }
  
  func joinEvent(eventID: Int) async {
    await self.eventRepository.joinEvent(userID: self.userID, eventID: eventID)
  }
}


