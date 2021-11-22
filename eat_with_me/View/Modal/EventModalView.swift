//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

struct EventModalView: View {
  @Binding var title: String
  @Binding var description: String
  @Binding var startDatetime: Date
  @Binding var endDatetime: Date
  
  var action: (() -> Void)?
  
  var body: some View {
    VStack {
      Text("ごはんの詳細")
        .font(.title)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Form {
        Section {
          TextField("タイトルを入力", text: $title)
          TextEditor(text: $description)
            
          DatePicker(selection: $startDatetime,
                      label: {Text("日時")})
          DatePicker(selection: $endDatetime,
                      label: {Text("日時")})
        }
        Section {
          Button(action: action!) {
            Text("作成")
          }
        }
      }
      Spacer()
   }
  }
}

//struct EventModal_Previews: PreviewProvider {
//    static var previews: some View {
//      EventModalView()
//    }
//}
