//
//  Constants.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-28.
//


import Foundation

public class Contants {
    
    public static let userName = "userName";
    
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
