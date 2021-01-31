//
//  User InfoView.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/30.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject var userModel = UserViewModel()
    @AppStorage("UD_isUsingBioID") var UD_isUsingBioID = false
    
    var body: some View {
        List {
            VStack {
                HStack {
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80, alignment: .center)
                    VStack(alignment: .leading) {
                        Text("账号")
                            .font(.subheadline)
                        Text("\(UserViewModel.currentUserInfo())")
                    }
                }
            }
            Section{
            VStack{
                Toggle("是否启用生物识别登录", isOn: $UD_isUsingBioID)
            }
            }
            Section{
                VStack(alignment:.center) {
                    Button(action: {
                        self.userModel.userLogOut()
                    }, label: {
                        Text("退出当前账号")
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                    })
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("账号")
        .navigationBarHidden(false)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserInfoView()
        }
    }
}
