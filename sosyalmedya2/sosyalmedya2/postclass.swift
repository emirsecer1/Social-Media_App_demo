//
//  postclass.swift
//  sosyalmedya2
//
//  Created by Emir Seçer on 12.09.2023.
//

import Foundation

class post {
    var email :String
    var yorum :String
    var gorselurl :String
    
    init(email: String, yorum: String, gorselurl: String) {
        self.email = email
        self.yorum = yorum
        self.gorselurl = gorselurl
    }
}
