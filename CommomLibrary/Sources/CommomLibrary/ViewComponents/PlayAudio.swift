//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-10.
//

import SwiftUI
import AVKit

public struct PlayAudio: View {
    var player: AVPlayer
    var isReady: Bool = false
    
    public init(url:String, isAutoPlay: Bool = true){
        if let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let audioURL = URL(string: url){
            player = AVPlayer(url: audioURL)
            isReady = true
            if isAutoPlay{
                player.play()
            }
        }else{
            print(url)
            player = AVPlayer()
        }
    }
    
    public var body: some View {
        ZStack{
            if isReady{
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
                        player.rate = 0.6
                    }) {
                        Text(Image(systemName: "tortoise.fill"))
                    }
                }
            }
        }
    }
}

struct PlayAudio_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            PlayAudio(url: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/Health/Symptoms and Injuries/decongestant.wav", isAutoPlay: false)
            PlayAudio(url: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/audio/Recreation/Winter and Water Sports/kayak.wav", isAutoPlay: false)

        }
    }
}
