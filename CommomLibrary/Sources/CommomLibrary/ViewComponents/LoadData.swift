//
//  File.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import Foundation

public func loadDataByServer<T: Decodable>(url: String) async -> T?{
    guard let url = URL(string: url) else { return nil}
    
    do{
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch let error{
        print("load Data error:\n\(error)")
        return nil
    }
}
