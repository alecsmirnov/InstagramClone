//
//  NetworkResult.swift
//  Instagram
//
//  Created by Admin on 25.01.2021.
//

enum NetworkResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
