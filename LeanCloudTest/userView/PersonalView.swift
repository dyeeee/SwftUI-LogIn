//
//  PersonalView.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/30.
//

import SwiftUI
import LeanCloud

struct PersonalView: View {
    @StateObject var userModel = UserViewModel()
    @AppStorage("UD_isLogged") var UD_isLogged = true
    @AppStorage("UD_isUsingBioID") var UD_isUsingBioID = false
    
    var body: some View {
        NavigationView{
            if (UD_isLogged && self.userModel.isLocalSessionVertified) {
                UserInfoView(userModel: self.userModel)
            }
            else{
                LogInView(userModel:self.userModel).navigationBarHidden(true)
                
            }
        }.onAppear(perform: {
            self.userModel.vertifyLocalSession()
        })
        
    }}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView(UD_isLogged: true)
    }
}
