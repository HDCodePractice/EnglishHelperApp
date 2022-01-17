//
//  File.swift
//  
//
//  Created by 老房东 on 2022-01-17.
//

import SwiftUI


class ImportDictViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    var dictName: String = "picwords"
    let imageName: String = "fruit1"
    let manager = LocalDictFileManager.instance
    @Published var infoMessage: String = ""
    @Published var localDictList : [String] = []
    
    init(){
        checkLocalDictList()
    }
    
    func checkLocalDictList(){
        manager.checkLocalDicts()
        localDictList = manager.localDicts
    }
    
    func getImageFromFileManager(){
        image = manager.getImage(name: imageName)
    }
        
    func deleteImage(){
        infoMessage = manager.deleteImage(name: imageName)
    }
    
    func cleanDict(){
        infoMessage = manager.deleteItem(itemName: "\(dictName)")
        infoMessage += manager.deleteItem(itemName: "\(dictName).json")
    }
    
    func importZIPFile(zipfile: URL){
        infoMessage = manager.unZipImportFile(sourceURL: zipfile)
        checkLocalDictList()
    }
}
