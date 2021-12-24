//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/18.
//
import Combine
import Foundation

//public final class ModelData:ObservableObject{
//    @Published var grammars: [Grammar] = load("grammar.json")
//    public init(){}
//}

var grammars: [Grammar] = load("grammar.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
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
