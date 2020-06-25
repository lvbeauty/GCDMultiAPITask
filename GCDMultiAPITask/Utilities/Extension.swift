//
//  Extension.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

extension UIImageView
{
    func roundedCornerImage()
    {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
