//
//  JSONCoding.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

import Foundation

enum JSONCoding {
    static func toDictionary<T>(_ data: T) -> [String: Any]? where T: Encodable {
        var dictionary: [String: Any]?
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            let dictionaryData = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            
            dictionary = dictionaryData as? [String: Any]
        } catch let error {
            print("Unable to encode into dictionary: \(error.localizedDescription)")
        }
        
        return dictionary
    }
    
    static func fromDictionary<T>(_ dictionary: [String: Any], type: T.Type) -> T? where T: Decodable {
        var jsonType: T?
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            
            jsonType = try jsonDecoder.decode(T.self, from: jsonData)
        } catch let error {
            print("Unable to decode type: \(error.localizedDescription)")
        }
        
        return jsonType
    }
}
