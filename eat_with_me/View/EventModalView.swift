//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

struct EventModalView: View {
  @State var title = ""
  @State var description = ""
  @State var date = Date()
  
  var action: (() -> Void)?
  
  var body: some View {
    VStack {
      Text("ごはんの詳細")
        .font(.title)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      
//      NavigationView {
      Form {
        Section {
          TextField("タイトルを入力", text: $title)
  //        TextField("説明を入力", text: $description)
  //          .frame(maxWidth: .infinity)
  //          .frame(height: 80)
          TextEditor(text: $description)
  //          Text("こんにちは！\(title)")
            
          DatePicker(selection: $date,
                      label: {Text("日時")})
        }
        Section {
          Button(action: action!) {
            Text("作成")
          }
        }
          
      }
//      .padding(0)
//      .frame(maxWidth: .infinity)
//        .navigationBarTitle("ごはんの詳細")
//        .navigationBarTitleDisplayMode(.automatic)
      Spacer()
   }
  }
}

struct EventModal_Previews: PreviewProvider {
    static var previews: some View {
      EventModalView()
    }
}
