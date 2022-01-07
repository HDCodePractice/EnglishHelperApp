//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-05.
//

import SwiftUI

struct PictureProgressView: View {
    @EnvironmentObject var pictureManager : PictureManager
    
    var body: some View {
        if pictureManager.reachedEnd{
            VStack(spacing:20){
                Text("Picture Game")
                    .liacTitle()
                Text("Congratulations, you completed the game!")
                
                Text("You scored \(1) out of \(10)")
                
                Button{
                    pictureManager.generatePictures()
                }label: {
                    PrimaryButton(text: "Play again")
                }
            }
            .foregroundColor(Color("AccentColor"))
            .padding()
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color("background"))
        }else{
            PictureQuesionView()
        }
    }
}

struct PictureProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PictureProgressView()
            .environmentObject(PictureManager())
    }
}
