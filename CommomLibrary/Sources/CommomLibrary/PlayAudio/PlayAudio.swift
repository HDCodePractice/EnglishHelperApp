//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-10.
//

import SwiftUI
import AVKit

public struct PlayAudio: View {
    var player : AVPlayer
    
    public init(url:String, isAutoPlay: Bool = true){
        player = AVPlayer(url: URL(string: url)!)
        if isAutoPlay{
            player.play()
        }
    }
    
    public var body: some View {
        ZStack{
            HStack{
                Button(action: {
                    player.seek(to: CMTime(seconds: 0, preferredTimescale: 10))
                    player.play()
                }) {
                    Text(Image(systemName: "play.fill"))
                }
                
                Button(action: {
                    player.seek(to: CMTime(seconds: 0, preferredTimescale: 10))
                    player.play()
                    player.rate = 0.5
                }) {
                    Text(Image(systemName: "tortoise.fill"))
                }
            }
        }
    }
}

struct PlayAudio_Previews: PreviewProvider {
    static var previews: some View {
        PlayAudio(url: "https://s3.amazonaws.com/kargopolov/kukushka.mp3", isAutoPlay: false)
    }
}
