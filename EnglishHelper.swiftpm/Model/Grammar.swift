//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/18.
//

import Foundation

enum FetchError: Error{
    case badFetch
    case badData
}


struct Grammar{
    var name: String = ""
    var url: String = ""
    var markdown : String = ""
}

extension Grammar: Codable {}
extension Grammar: Identifiable{
    var id: String {
        return self.name
    }
}


func fetchMarkdown(from url:URL) async throws-> String? {
    let (data,response) = try! await URLSession.shared.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badFetch }
    let markdownString = data.base64EncodedString()
    return markdownString
}
