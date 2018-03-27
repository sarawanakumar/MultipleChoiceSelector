//
//  TargetActionPair.swift
//  CollectorTester
//
//  Created by Sarawanak on 3/26/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import Foundation

class TargetActionPair: NSObject {
    var target: Any?
    var selector: Selector?

    class func pairWithTarget(target: Any, selector: Selector) -> TargetActionPair {
        let tap = TargetActionPair()
        tap.target = target
        tap.selector = selector
        return tap
    }

    func fire() {

    }
}
