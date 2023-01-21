//
//  MulticastDelegate.swift
//  AdsRepo
//
//  Created by Ali on 1/19/23.
//

import Foundation

public class MulticastDelegate<T> {
    
    private class Wrapper {
        weak var observer: AnyObject?
        
        init(_ observer: AnyObject) {
            self.observer = observer
        }
    }
    
    private var wrappers: [Wrapper] = []
    
    public var delegates: [T] {
        wrappers = wrappers.filter{ $0.observer != nil }
        return wrappers.compactMap{ $0.observer } as! [T]
    }
    
    public func append(observer: T) {
        let wrapper = Wrapper(observer as AnyObject)
        wrappers.append(wrapper)
    }
    
    public func remove(observer: T) {
        guard let index = wrappers.firstIndex(where: {
            $0.observer === (observer as AnyObject)
        }) else {
            return
        }
        wrappers.remove(at: index)
    }
    
    public func invokeForEachDelegate(_ handler: (T) -> ()) {
        delegates.forEach { handler($0) }
    }
}
