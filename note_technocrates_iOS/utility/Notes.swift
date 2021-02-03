//
//  Notes.swift
//  note_technocrates_iOS
//
//  Created by Macbook on 2021-01-28.
//

import Foundation

class Note{
    
    var titleName : String;
    var description : String;
    var createdAt : Int64;
    var lat : Double;
    var long : Double;
    var categoryName : String;
    var imageData: Data;
    
    init() {
      
        self.titleName = String();
        self.description = String();
        self.categoryName = String();
        
        self.lat = Double();
        self.long = Double();
        self.createdAt = Int64();
        self.imageData = Data();
    }
    
}
