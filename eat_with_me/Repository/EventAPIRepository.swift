//
//  EventAPIRepository.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/25.
//

import Foundation

struct EventCodable: Codable {
  let id: Int
  let title: String
  let description: String
  let start_datetime: Date
  let end_datetime: Date
  let organize_user_id: Int
  let latitude: Double
  let longitude: Double
  let organize_user: UserCodable
  let join_users: [UserCodable]
  
  func toEvent() -> Event {
    
    var users: [User] = []
    for u in self.join_users {
      users.append(u.toUser())
    }
    
    return Event(
      id: self.id,
      title: self.title,
      description: self.description,
      startDatetime: self.start_datetime,
      endDatetime: self.end_datetime,
      latitude: self.latitude,
      longitude: self.longitude,
      organizeUser: self.organize_user.toUser(),
      joinUsers: users
    )
  }
}

struct CreateEventCodable: Codable {
  let title: String
  let description: String
  let start_datetime: Date
  let end_datetime: Date
  let organize_user_id: Int
  let latitude: Double
  let longitude: Double
}

struct UpdateEventCodable: Codable {
  let id: Int
  let title: String
  let description: String
  let start_datetime: Date
  let end_datetime: Date
  let organize_user_id: Int
  let latitude: Double
  let longitude: Double
}

struct FetchEventResult: Codable {
  let event: EventCodable
}

struct FetchRelatedEventsResult: Codable {
  let events: [EventCodable]
  let user: UserCodable
}

struct CreateEventsResult: Codable {
  let event: EventCodable
}

struct CreateEventBody: Codable {
  var event: CreateEventCodable
}

struct UpdateEventBody: Codable {
  var event: UpdateEventCodable
}

struct JoinEventBody: Codable {
  let user_id: Int
}

class EventAPIRepository: APIRepository {
  
  func fetchEvent(eventID: Int64) async -> Event {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/events/\(eventID)")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let json = try! decoder.decode(FetchEventResult.self, from: data!)
    let item = json.event
    
    return item.toEvent()
  }
  
  func fetchRelatedEvents(userID: Int64) async -> [Event] {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/events")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    print("data", String(data: data!, encoding: .utf8))
    
    let json = try! decoder.decode(FetchRelatedEventsResult.self, from: data!)
    let eventsCodable = json.events
    
    var events: [Event] = []
    for e in eventsCodable {
      events.append(e.toEvent())
    }
    return events
  }
  
  func createEvent(requestBody: CreateEventBody) async {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/events")
    requestEntity.setToken()
    requestEntity.setPostRequest()
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try! encoder.encode(requestBody)
    let jsonstr: String = String(data: jsonData, encoding: .utf8)!
    requestEntity.setJsonBody(json: jsonstr)
    
    await self.request(requestEntity: requestEntity)
  }
  
  func joinEvent(userID: Int, eventID: Int) async {
    var requestBody = JoinEventBody(user_id: userID)
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/events/\(eventID)/join")
    requestEntity.setToken()
    requestEntity.setPostRequest()
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try! encoder.encode(requestBody)
    let jsonstr: String = String(data: jsonData, encoding: .utf8)!
    requestEntity.setJsonBody(json: jsonstr)
    
    await self.request(requestEntity: requestEntity)
  }
  
  func updateEvent(requestBody: UpdateEventBody) async {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/events/\(requestBody.event.id)")
    requestEntity.setToken()
    requestEntity.setPutRequest()
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try! encoder.encode(requestBody)
    let jsonstr: String = String(data: jsonData, encoding: .utf8)!
    requestEntity.setJsonBody(json: jsonstr)
    
    print("update event", jsonstr)
    
    await self.request(requestEntity: requestEntity)
  }
}
