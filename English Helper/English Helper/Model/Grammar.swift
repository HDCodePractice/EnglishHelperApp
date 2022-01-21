//
//  Grammar.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-19.
//

import Foundation

enum FetchError: Error{
    case badFetch
    case badData
}


struct Grammars: Codable{
    var grammars = [Grammar]()
}

struct Grammar: Codable{
    var name: String = ""
    var url: String = ""
    var markdown : String?
    var description : String?
}

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
