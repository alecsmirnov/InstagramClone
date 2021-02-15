//
//  FirebaseObserver.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import FirebaseDatabase

struct FirebaseObserver {
    // MARK: Properties
    
    private let reference: DatabaseReference
    private let handle: UInt
    
    // MARK: Initialization
    
    init(reference: DatabaseReference, handle: UInt) {
        self.reference = reference
        self.handle = handle
    }
}

// MARK: - Public Methods

extension FirebaseObserver {
    func remove() {
        reference.removeObserver(withHandle: handle)
    }
}
