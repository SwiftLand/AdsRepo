//
//  AtomicProperty.swift
//  react-native-track-player
//
//  Created by Ali on 8/30/22.
//

import Foundation
@propertyWrapper
public struct Atomic<Value> {

    private var value: Value
    private let queue:DispatchQueue

    public init(wrappedValue value: Value,name:String? = nil) {
        self.value = value
        self.queue = DispatchQueue(label: "com.AdsRepo.atomicVar\(name == nil ? "" : ".\(name!)")")
    }
    
    public init(wrappedValue value: Value,queue:DispatchQueue){
        self.value = value
        self.queue = queue
    }
    
    public var wrappedValue: Value {
        get { return queue.sync { value } }
        set { queue.sync { value = newValue } }
    }
}
