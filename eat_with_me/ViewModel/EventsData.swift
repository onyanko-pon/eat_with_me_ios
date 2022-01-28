//
//  EventsData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

class EventsData: ObservableObject {
  @Published var events: [Event] = []
  var userID: Int
  var eventRepository: EventAPIRepository = EventAPIRepository()

  init(userID: Int) {
    self.userID = userID
    async {
      await fetchEvents(userID: userID)
    }
  }
  
  func fetchEvents(userID: Int) async {
    if userID == 0 {
      return
    }
    let events = await eventRepository.fetchRelatedEvents(userID: Int64(self.userID))
    self.events = events
  }
  
  func addEvent(event: Event) async {
    let eventBody = CreateEventBody(
      event: CreateEventCodable(
        title: event.title,
        description: event.description,
        start_datetime: event.startDatetime,
        end_datetime: event.endDatetime,
        organize_user_id: self.userID,
        latitude: event.latitude,
        longitude: event.longitude
      )
    )
    
    await self.eventRepository.createEvent(requestBody: eventBody)
    await self.fetchEvents(userID: self.userID)
  }
  
  func updateEvent(event: Event) async {
    let eventBody = UpdateEventBody(
      event: UpdateEventCodable(
        id: event.id,
        title: event.title,
        description: event.description,
        start_datetime: event.startDatetime,
        end_datetime: event.endDatetime,
        organize_user_id: self.userID,
        latitude: event.latitude,
        longitude: event.longitude
      )
    )
    
    await self.eventRepository.updateEvent(requestBody: eventBody)
    await self.fetchEvents(userID: self.userID)
  }
}


