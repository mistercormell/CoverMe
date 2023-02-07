//
//  TimetableFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

class TimetableFileReader {
    
    func createTimetableFromFile(filename: String) {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
            } catch {
                print("Couldn't load contents of file")
            }
        } else {
            print("File not found!")
        }
    }
    
}
