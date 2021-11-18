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
  @Binding var event: Event
  
  var body: some View {
    VStack {
      // タイトルと時間
      HStack {
        VStack {
          Text(event.title)
            .fontWeight(.heavy)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 1)
          
          
          Text(genDateString(date: event.date))
            .padding(.top, 0.0)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        PerticipateButton(action: {
          
        })
      }
      .padding(.bottom, 15)
      
      HStack {
        
        ForEach(event.participants) { participant in
          UserIcon(url: participant.imageURL)
        }
        Spacer()
      }
      .frame(alignment: .leading)
      .padding(.bottom, 16)
      
      Text(event.description)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.body)
        .lineSpacing(6)
        .padding(.top, 4)
        .padding(.bottom, 4)
      
    }
    .padding(.all, 24)
    .onAppear(perform: {
      print(event)
    })
  }
}

var previewUser = User(
  username: "username",
  imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png"
)

var previewEvent = Event(
  title: "タイトル",
  description: "今日はちょっと奮発して焼肉ランチに行きましょう\n開発チーム以外の人もぜひ参加してください",
  date: Date(),
  latitude: 0.0,
  longitude: 0.0,
  imageURL: "https://pics.prcm.jp/e3d9c42a77b3f/84581569/jpeg/84581569.jpeg",
  participants: [previewUser]
)

struct EventDetailModal_Previews: PreviewProvider {
  static var previews: some View {
    PreviewWrapper()
  }

  struct PreviewWrapper: View {
    @State(initialValue: previewEvent) var event: Event
    var body: some View {
      EventDetailModal(event: $event)
    }
  }
}
