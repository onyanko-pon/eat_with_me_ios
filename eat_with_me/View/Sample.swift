//
//  Sample.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

struct Sample: View {
    var foods = ["カレー", "焼肉", "ラーメン"]
    @State var name = ""
    @State var selected = 0
    @State var birthDate = Date()
     
    var body: some View {
        NavigationView {
            Form {
                TextField("氏名を入力してください", text: $name)
                Text("こんにちは！\(name)")
                 
                DatePicker(selection: $birthDate,
                           label: {Text("生年月日")})
                 
                Picker(selection: $selected,
                       label: Text("好きな食べ物")) {
                        ForEach(0..<foods.count) {
                            Text(self.foods[$0])
                        }
                }
                 
                Button(action: {}) {
                    Text("確定")
                }
            }
            .navigationBarTitle("入力画面")
        }
    }
}

struct Sample_Previews: PreviewProvider {
    static var previews: some View {
      Sample()
    }
}
