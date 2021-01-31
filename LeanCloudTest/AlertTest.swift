//
//  AlertTest.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/30.
//

import SwiftUI

struct AlertTestView: View {
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false

    var body: some View {
        VStack {
            Button("Show 1") {
                self.showingAlert1 = true
            }
            .alert(isPresented: $showingAlert1) {
                Alert(title: Text("One"), message: nil, dismissButton: .cancel())
            }

            Button("Show 2") {
                self.showingAlert2 = true
            }
            .alert(isPresented: $showingAlert2) {
                Alert(title: Text("启用生物识别"), message: Text("是否使用TouchID/FaceID来登录"), primaryButton: .cancel(Text("启用").foregroundColor(.black), action: {}), secondaryButton: .destructive(Text("不启用"), action: {}))
            }
        }
    }
}
struct AlertTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlertTestView()
        }
    }
}

