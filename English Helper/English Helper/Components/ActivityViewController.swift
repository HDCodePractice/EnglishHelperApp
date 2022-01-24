//
//  ActivityViewContreal.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-24.
//

import SwiftUI
import ActivityView


struct TestView: View {
    @State private var item : ActivityItem?
    
    var body: some View {
        Button{
            let scenes = UIApplication.shared.connectedScenes
            if let windowScenes = scenes.first as? UIWindowScene,let window = windowScenes.windows.first{
                item =  ActivityItem(items: window.asImage(),"This will be shared" )
            }
        } label:{
            Text("share")
        }
        .activitySheet($item)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
