//
//  LearnEnglishHelperViewModel.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-05-03.
//

import Foundation
import CommomLibrary

class LearnEnglishHelperViewModel:ObservableObject{
    private var realmController : RealmController
    
    @Published var isLoading = true
    
    init(){
        realmController = RealmController.shared
        Task{
            await fetchData()
        }
    }
    
    func fetchData() async{
        isLoading = true
        await realmController.fetchData()
        isLoading = false
    }
}
