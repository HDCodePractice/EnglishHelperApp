//
//  File.swift
//  
//
//  Created by 老房东 on 2022-01-17.
//

import SwiftUI
import Zip

class LocalDictFileManager{
    static let instance = LocalDictFileManager()
    let supportDicts : [String] = ["picwords"]
    let forderName = "import_dict"
    var localDicts: [String] = []
    
    init(){
        createFolderIfNeed()
        checkLocalDicts()
    }
    
    func getDictJson(_ dictName: String) -> URL?{
        guard let path = getPathURL("\(forderName)/\(dictName).json") else {
            return nil
        }
        return path
    }
    
    func getDictPicturePath(_ dictName: String,_ pictureName: String) -> String?{
        guard let path = getPathURL("\(forderName)/\(dictName)/\(pictureName).jpg") else {
            return nil
        }
        return path.path
    }
    
    func checkLocalDicts(){
        localDicts = []
        for dict in supportDicts {
            guard let jsonPath = getPathURL("\(forderName)/\(dict).json")else {
                break
            }
            if FileManager.default.fileExists(atPath: jsonPath.path) {
                localDicts.append(dict)
            }
        }
    }
    
    func unZipImportFile(sourceURL: URL) -> String{
        guard let path = getPathURL(forderName) else{
            return "Error getting dict directory path."
        }
        do{
            try Zip.unzipFile(sourceURL, destination: path, overwrite: true, password: nil, progress: { progress in print(progress) })
        }catch let error{
            return "unzip error. \(error)"
        }
        
        return "Success import"
    }
    
    func createFolderIfNeed(){
        guard let path = getPathURL(forderName) else {
                    print("Error getting dict directory path.")
                    return
                }
        
        if !FileManager.default.fileExists(atPath: path.path){
            do{
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder.")
            } catch let error{
                print("Error create directory.\(error)")
            }
        }
        
    }
    
    func deleteItem(itemName: String)-> String{
        guard let path = getPathURL("\(forderName)/\(itemName)") else {
            return "Error getting item path."
        }
        
        do{
            try FileManager.default.removeItem(at: path)
            return "Sucess item."
        }catch let error{
            return "Error deleting item. \(error)"
        }

    }
    
    func saveImage(image: UIImage, name: String)-> String{
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPahtForImage(name: name) else {
            return("Error get image data.")
        }

        do{
            try data.write(to: path)
            return "Sucessfully saving !"
        }catch let error{
            return("Error saving. \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        guard
            let path = getPahtForImage(name: name),
            FileManager.default.fileExists(atPath: path.absoluteString) else{
                print("Error getting path.")
                return nil
            }
        
        return UIImage(contentsOfFile: path.absoluteString)
    }
    
    func getPahtForImage(name: String) -> URL?{
        guard let path = getPathURL("\(forderName)/\(name).jpg") else {
                    print("Error getting document path.")
                    return nil
                }
        return path
    }
    
    func deleteImage(name: String) -> String{
        guard
            let path = getPahtForImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else{
                return("Error getting path.")
            }
        
        do{
            try FileManager.default.removeItem(at: path)
            return "Sucessfully deleted !"
        }catch let error{
            return "Error deleting image. \(error)"
        }
    }
    
    private func getPathURL(_ subPathName : String)-> URL?{
        guard let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(subPathName) else {
                    return nil
                }
        return path
    }
}
