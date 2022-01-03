//
//  Extensions.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021-12-31.
//

import Foundation
import SwiftUI

extension Text{
    func liacTitle() -> some View{
        self.font(.title)
            .fontWeight(.heavy)
            .foregroundColor(Color("AccentColor"))
    }
}

enum Device {
    //MARK: 当前设备类型 iphone ipad mac
    enum Devicetype{
        case iphone,ipad,mac
    }
    
    static var deviceType:Devicetype{
        #if os(macOS)
        return .mac
        #else
        if  UIDevice.current.userInterfaceIdiom == .pad {
            return .ipad
        }
        else {
            return .iphone
        }
        #endif
    }
 }
    
extension View {
    @ViewBuilder func ifIs<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func ifElse<T:View,V:View>( _ condition:Bool,isTransform:(Self) -> T,elseTransform:(Self) -> V) -> some View {
        if condition {
            isTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

//VStack{
//     Text("hello world")
//}
//.ifIs(Deivce.deviceType == .iphone){
//  $0.frame(width:150)
//}
//.ifIs(Device.deviceType == .ipad){
//  $0.frame(width:300)
//}
//.ifIs(Device.deviceType == .mac){
//  $0.frmae(minWidth:200,maxWidth:600)
//}
