//
//  LoginViewModel.swift
//  Login_Face_ID
//
//  Created by Balaji on 07/10/20.
//

import SwiftUI
import LocalAuthentication
import LeanCloud
import Foundation

class UserViewModel : ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    @Published var phonenum = ""
    @Published var username = ""
    
    
    // UserDefault数据
    @AppStorage("UD_storedUser") var UD_storedUser = ""
    @AppStorage("UD_storedPassword") var UD_storedPassword = ""
    @AppStorage("UD_userSession") var UD_userSession = ""
    @AppStorage("UD_isUsingBioID") var UD_isUsingBioID = false
    
    @AppStorage("UD_isLogged") var UD_isLogged = false
    @Published var isLocalSessionVertified:Bool = false
    
    
    // Loading Screen...
    @Published var isLoading = false
    
    //用户提示
    @Published var signUpAlert = false
    @Published var signUpAlertMsg = ""
    
    @Published var logInAlert = false
    @Published var logInAlertMsg = ""
    
    @Published var bioUsingAlert = false
    
    // 判断是否有Bio识别
    func getBioMetricStatus()->Bool{
        let bioContext = LAContext()
        var error:NSError?
        let result = bioContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return result
    }
    
    func authenticateUser(){
        let context = LAContext()
        context.localizedFallbackTitle = "其它方式"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用生物识别解锁\(email)") { (success, err) in
            if success {
                DispatchQueue.main.async {
                    //表示验证成功
                    self.email = self.UD_storedUser
                    self.password = self.UD_storedPassword  //验证通过就用存在本地的密码去登录
                    self.userLogIn()
                }
            }
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
        }
    }
    
    //用户注册
    func userSignUp() {
        isLoading = true
        
        // 创建实例
        let user = LCUser()
        
        // 等同于 user.set("username", value: "Tom")
        user.username = LCString("\(self.email)")
        user.password = LCString("\(self.password)")
        
        // 可选
        user.email = LCString("\(self.email)")
        //user.mobilePhoneNumber = LCString("+8618200008888")
        
        _ = user.signUp { [self] (result) in
            self.isLoading = false
            switch result {
            case .success:
                self.UD_isLogged = true
                self.userLogIn()
                break
            case .failure(error: let error):
                switch error.code {
                case 203:
                    self.signUpAlertMsg = "此电子邮箱已被注册\n请前往登录或使用未被注册的邮箱"
                default:
                    self.signUpAlertMsg = error.localizedDescription
                }
                self.signUpAlert.toggle()
                print(error)
                print(self.signUpAlert)
                return
            }
        }
    }
    
    // 用户登录
    func userLogIn(){
        //开启动画
        isLoading = true
        
        _ = LCUser.logIn(email: email, password: password) { [self] result in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2){
                self.isLoading = false //关闭动画
            }
            switch result {
            case .success(object: let user):
                self.UD_userSession = LCApplication.default.currentUser?.sessionToken?.value ?? "noSession"
                self.UD_storedUser = self.email
                self.UD_storedPassword = self.password
                
                print("\(user)登录成功")
                
                //如果没有开启生物识别则询问是否要启用
                if !self.UD_isUsingBioID{
                    self.bioUsingAlert = true
                    //这里注意要在alert中处理登录逻辑
                    return
                }else{
                //进入主页面
                withAnimation{
                    print("准备进入主页面")
                    self.UD_isLogged = true
                    print("本地验证结果: \(self.UD_isLogged)")
                    self.vertifyLocalSession()
                }
                }
                
 
            case .failure(error: let error):
                print(error)
                switch error.code {
                case 210:
                    self.logInAlertMsg = "用户名或密码错误"
                default:
                    self.logInAlertMsg = error.localizedDescription
                }
                self.logInAlert.toggle()
                return
            }
        }
    }
    
    func userLogOut() {
        LCUser.logOut()
//        UD_storedUser = ""
//        UD_storedPassword = ""
        UD_userSession = ""
        password = ""
        //添加一个询问要不要清除faceID记录
        withAnimation{
            UD_isLogged = false
        }
//        print("本地记录已被清除")
    }
    
    //    func setUserInfo() {
    //        _ = LCUser.logIn(email: "\(self.email)", password: "\(self.UD_storedPassword)") { result in
    //            switch result {
    //            case .success(object: let user):
    //                // 试图修改用户名
    //                try! user.set("username", value: "\(self.username)")
    //                // 可以执行，因为用户已鉴权
    //                user.save()
    //            case .failure(error: let error):
    //                print(error)
    //            }
    //        }
    //    }
    
    class func currentUserInfo() -> String {
        if let user = LCApplication.default.currentUser {
            // 跳到首页
            print("获取到当前用户")
            return user.email?.value ?? "获取邮箱失败"
        } else {
            // 显示注册或登录页面
            print("获取用户失败")
            return "获取用户失败"
        }
    }
    
    func vertifyLocalSession() {
        let UD_userSession = UserDefaults.standard.string(forKey: "UD_userSession")
        
        _ = LCUser.logIn(sessionToken: "\(UD_userSession ?? "noSession")") { (result) in
            switch result {
            case .success(object: let user):
                // 登录成功
                print("Session云端验证成功: \(user)")
                self.isLocalSessionVertified = true
            case .failure(error: let error):
                // session token 无效
                print("Session云端验证失败: \(error)")
                self.isLocalSessionVertified = false
            }
        }
    }
    
    
    
    //初始化设置
    class func LeanCloudSet() {
        //LCApplication.logLevel = .verbose
        do {
            try LCApplication.default.set(
                id: "7VqW9WIS3vtxkGGVq2SBPwsw-gzGzoHsz",
                key: "IiLymQt8v9qOzzU41K48CwxC",
                serverURL: "https://7vqw9wis.lc-cn-n1-shared.com")
        } catch {
            print(error)
        }
    }
    
    //网络连通性测试
    class func LeanCloudTest() {
        do {
            let testObject = LCObject(className: "TestObject")
            try testObject.set("words", value: "Hello world!")
            let result = testObject.save()
            if let error = result.error {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
