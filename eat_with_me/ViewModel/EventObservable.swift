//
//  EventObservable.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

class EventObserable: ObservableObject {
  @Published var title = ""
  @Published var description = ""
  @Published var date = Date()
}
