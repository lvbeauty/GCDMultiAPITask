//
//  Service.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

class Service
{
    static let shared = Service()
    private init() {}
    
    func fetchRemoteData(url: URL) -> Data?
    {
        var data: Data?
        
        do
        {
            data = try Data(contentsOf: url)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return data
    }
}
