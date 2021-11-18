//
//  EventsData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

class EventsData: ObservableObject {
  @Published var events: [Event] = []
  
  func appendEvent(event :Event) {
    self.events.append(event)
  }
  
  func perticipantAdd(eventID :UUID, participant :User) {
    for i in 0 ..< self.events.count {
      
      if self.events[i].id == eventID {
        self.events[i].participants.append(participant)
        return
      }
    }
    // 例外投げたい
  }
}

