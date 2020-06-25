//
//  DataModel.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

struct User: Decodable
{
    var email: String
    var first_name: String
    var last_name: String
    var avatar: URL
}
// perform only use People
struct People: Decodable
{
    var data: [User]
}

struct Person: Decodable
{
    var data: User
}


