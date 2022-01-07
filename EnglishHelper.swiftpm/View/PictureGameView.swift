//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-05.
//

import SwiftUI

struct PictureGameView: View {
    @StateObject var pictureManager = PictureManager()
    
    var body: some View {
        NavigationView{
            VStack(spacing:40){
                VStack(spacing:20){
                    Text("Picture Game")
                        .liacTitle()
                    Text("Are you ready to test out English words?")
                        .foregroundColor(Color("AccentColor"))
                }
                NavigationLink{
                    PictureProgressView()
                        .environmentObject(pictureManager)
                }label: {
                    PrimaryButton(text: "Let't go!")
                }
                
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(Color("background"))
        }.navigationViewStyle(.stack)
    }
}

struct PictureGameView_Previews: PreviewProvider {
    static var previews: some View {
        PictureGameView()
    }
}
