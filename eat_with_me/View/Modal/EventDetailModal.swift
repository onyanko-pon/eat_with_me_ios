//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import SwiftUI

func genDateString(date :Date) -> String {
  let df = DateFormatter()
  df.dateFormat = "MM月dd日 HH時mm分ごろ"
  return df.string(from: date)
}

struct EventDetailModal: View {
//  @Binding var event: Event?
  @ObservedObject var eventDetailData: EventDetailData
  
  var body: some View {
    VStack {
      // タイトルと時間
      HStack {
        VStack {
          if let title = eventDetailData.event?.title {
            Text(title)
              .fontWeight(.heavy)
              .font(.title)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.bottom, 1)
          }
          
          if let startDatetime = eventDetailData.event?.startDatetime {
            Text(genDateString(date: startDatetime))
              .padding(.top, 0.0)
              .foregroundColor(.gray)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        if let eventID = eventDetailData.event?.id {
          PerticipateButton(action: {
            eventDetailData.joinEvent(eventID: eventID)
          })
        }
      }
      .padding(.bottom, 15)
      
      HStack {
        
        if let organizeUser = eventDetailData.event?.organizeUser {
          UserIcon(url: organizeUser.imageURL)
        }
        if let participants = eventDetailData.event?.participants {
          ForEach(participants) { participant in
            UserIcon(url: participant.imageURL)
          }
          Spacer()
        }
      }
      .frame(alignment: .leading)
      .padding(.bottom, 16)
      
      if let description = eventDetailData.event?.description {
        Text(description)
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.body)
          .lineSpacing(6)
          .padding(.top, 4)
          .padding(.bottom, 4)
      }
      
    }
    .padding(.all, 24)
    .onAppear(perform: {
      print(eventDetailData.event)
    })
  }
}

var previewUser = User(
  id: 1,
  username: "username",
  imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png"
)

var previewEvent = Event(
  id: 1,
  title: "タイトル",
  description: "今日はちょっと奮発して焼肉ランチに行きましょう\n開発チーム以外の人もぜひ参加してください",
  startDatetime: Date(),
  endDatetime: Date(),
  latitude: 0.0,
  longitude: 0.0,
  imageURL: "https://pics.prcm.jp/e3d9c42a77b3f/84581569/jpeg/84581569.jpeg",
  organizeUser: previewUser,
  participants: [previewUser]
)

//struct EventDetailModal_Previews: PreviewProvider {
//  static var previews: some View {
//    PreviewWrapper()
//  }
//
//  struct PreviewWrapper: View {
//    @State(initialValue: previewEvent) var event: Event?
//    var body: some View {
//      EventDetailModal(event: $event)
//    }
//  }
//}
