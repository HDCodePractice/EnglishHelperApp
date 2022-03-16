//
//  About.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-11.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    
    var body: some View {
        VStack(spacing:20){
            Text("About Us")
                .font(.title)
 
            Text("Contributors")
                .font(.headline)
            Text("Jessie,[linbsd](https://github.com/linbsd), [Bernie](https://github.com/bernieharvard), [Raymond](https://github.com/raynix), [Sunny](https://github.com/sunnypo), [Sichengthebest](https://github.com/Sichengthebest), [老房东](https://github.com/hdcola)")
            Text("Thank")
                .font(.headline)
            Text("[Stephen](https://github.com/stephenzhu01)")
            Spacer()
            Text("Contact Us")
                .font(.headline)
            Text("[Telegram channel](https://t.me/englisherupdate), [Telegram group](https://t.me/+JBMuFwlPYNgxMjU1)")
            Text("The images used are from [Unsplash](https://unsplash.com), [pixabay](https://pixabay.com/zh),[botox icons] (https://www.flaticon.com/free-icons/botox),[ICONS8](https://icons8.com).")
            Text("Version:\(appVersion).\(build)")
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
