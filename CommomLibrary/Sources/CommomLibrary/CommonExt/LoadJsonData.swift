//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-25.
//

import Foundation
import OSLog

public func loadDataByServer<T: Decodable>(url: String) async -> T?{
    guard let url = URL(string: url) else { return nil}
    
    do{
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch let error{
        Logger().error("load Data error:\n\(error.localizedDescription)")
    }
    return nil
}

public func loadByURL<T: Decodable>(_ file: URL) -> T? {
    let data: Data
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        return nil
    }
}

public func load<T: Decodable>(_ filename: String, bundel: Bundle = Bundle.main) -> T {
    let data: Data
    
    guard let file = bundel.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in \(bundel) bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
