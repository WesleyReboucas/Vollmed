//
//  String+.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import Foundation

extension String {
    
    func convertDateStringToReadableDate() -> String {
        let inputForamatter = DateFormatter()
        inputForamatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = inputForamatter.date(from: self) {
            let dateForametter = DateFormatter()
            dateForametter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
            return dateForametter.string(from: date)
        }
        return ""
    }
}
