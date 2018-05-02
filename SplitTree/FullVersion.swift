//
//  FullVersion.swift
//  SplitTree
//
//  Created by Pieter Stragier on 02/05/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import Foundation

public struct SplitTreeFull {
    
    public static let FullVersion = "SplitTreeFull"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [SplitTreeFull.FullVersion]
    
    public static let store = IAPHelper(productIds: SplitTreeFull.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
