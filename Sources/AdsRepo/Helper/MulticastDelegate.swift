//
//  MulticastDelegate.swift
//  AdsRepo
//
//  Created by Ali on 1/19/23.
//

import Foundation

public class MulticastDelegate<T> {
    
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    var count:Int{delegates.count}
    
    func append(delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(delegate: T) {
        delegates.remove(delegate as AnyObject)
    }
    
    func removeAll() {
        delegates.removeAllObjects()
    }
    
   
    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
}
