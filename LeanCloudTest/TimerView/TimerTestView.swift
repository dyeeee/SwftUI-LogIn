//
//  TimerTestView.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/31.
//

import SwiftUI

struct TimerTestView: View {
    @State var timeRemaining = 10
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var text = ""
    
    @State var searching = false
    
    var body: some View {
        List {
            Section{
                VStack{
                    TextField("INPUT", text: $text)
                        .onChange(of: text, perform: { _ in
                            timeRemaining = 2
                            startTimer()
                        })
                }
            }
            
            Section{
                Text(searching ? "searching" : "no action")
            }
            
            VStack {
                Text("\(timeRemaining)")
                    .onAppear() {
                        self.stopTimer()
                    }
                    .onReceive(timer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        }
                        if self.timeRemaining == 0 {
                            //执行搜索操作
                            searching.toggle()
                            stopTimer()
                        }
                    }
            }
            
            
        }.listStyle(InsetGroupedListStyle())
        
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    
}

struct TimerTestView_Previews: PreviewProvider {
    static var previews: some View {
        TimerTestView()
    }
}
