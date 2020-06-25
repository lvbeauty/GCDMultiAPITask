//
//  ViewModel.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewModel
{
    init() { MultiGroupTasksForFetchingData() }
    
    var dataSource = [User]()
    let queue = DispatchQueue(label: "custom.queue", qos: .default, attributes: .concurrent)
    let group = DispatchGroup()
    var updateAIHandler: () -> () = {}
    var singleFlag = false
    
    var threadSafeData: [User] {
        get {
            queue.sync {
                return self.dataSource
            }
        }
        
        set {
            queue.async(flags: .barrier) {
                self.dataSource = newValue
            }
        }
    }
    
    func MultiGroupTasksForFetchingData()
    {
        group.enter()
        apiAsync(url: URL(string: "https://reqres.in/api/users?page=1"), flag: false)
        
        group.enter()
        apiAsync(url: URL(string: "https://reqres.in/api/users?page=2"), flag: false)
        
        group.enter()
        apiAsync(url: URL(string: "https://reqres.in/api/users/2"), flag: true)
        
        group.notify(queue: DispatchQueue.main)
        {
            self.updateAIHandler()
        }
    }
    
    func apiAsync(url: URL?, flag: Bool)
    {
        let queue1 = DispatchQueue(label: "custom.queue.1", qos: .default, attributes: .concurrent)
        queue1.asyncAfter(deadline: .now() + 0.5)
        {
            guard let url = url else {return}
            guard let fetchData = Service.shared.fetchRemoteData(url: url) else { return }
            
            self.singleFlag = flag
            
            self.threadSafeData.append(contentsOf: self.jsonDecode(data: fetchData))
            self.group.leave()
        }
    }
    
    func loadImage(row: Int, completeHandler: @escaping (UIImage?) -> Void)
    {
        let q = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        
        var imageData = Data()
        let workItem = DispatchWorkItem
        {
            guard let data = Service.shared.fetchRemoteData(url: self.dataSource[row].avatar) else { return }
    
            q.async(flags: .barrier) {
                imageData = data
            }
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main)
        {
            q.sync {
                guard let image = UIImage(data: imageData) else { return }
                completeHandler(image)
            }
        }
    }
    
    func jsonDecode(data: Data) -> [User]
    {
        var profiles = [User]()
        
        do
        {
            if singleFlag
            {
                let json = try JSONDecoder().decode(Person.self, from: data)
                profiles = [json.data]
            }
            else
            {
                let json = try JSONDecoder().decode(People.self, from: data)
                profiles = json.data
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return profiles
    }
}




//        DispatchQueue.global(qos: .background).async {
//            guard let imageData = Service.shared.fetchRemoteData(url: self.dataSource[row].avatar) else { return }
//
//            DispatchQueue.main.async {
//                guard let image = UIImage(data: imageData) else { return }
//                completeHandler(image)
//            }
//        }




//func secondAPIAsync()
//{
//    let queue2 = DispatchQueue(label: "custom.queue.2", qos: .default, attributes: .concurrent)
//    queue2.asyncAfter(deadline: .now() + 0.5) {
//        guard let url = URL(string: "https://reqres.in/api/users?page=2") else {return}
//        guard let fetchData = Service.shared.fetchRemoteData(url: url) else { return }
//
//        self.singleFlag = false
//
//        self.threadSafeData.append(contentsOf: self.jsonDecode(data: fetchData))
//        self.group.leave()
//    }
//}
//
//func thirdAPIAsync()
//{
//    let queue3 = DispatchQueue(label: "custom.queue.3", qos: .default, attributes: .concurrent)
//    queue3.asyncAfter(deadline: .now() + 0.5) {
//        guard let url = URL(string: "https://reqres.in/api/users/2") else {return}
//        guard let fetchData = Service.shared.fetchRemoteData(url: url) else { return }
//
//        self.singleFlag = true
//
//        self.threadSafeData.append(contentsOf: self.jsonDecode(data: fetchData))
//        self.group.leave()
//    }
//}
