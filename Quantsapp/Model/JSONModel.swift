//
//  JSONModel.swift
//  Quantsapp
//
//  Created by Srushti Dange on 20/07/22.
//

import Foundation
struct Json4Swift_Base : Codable {
    let l : String?
    let lu : String?
    let s : String?
    let sc : String?
    
    enum CodingKeys: String, CodingKey {
        
        case l = "l"
        case lu = "lu"
        case s = "s"
        case sc = "sc"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        l = try values.decodeIfPresent(String.self, forKey: .l)
        lu = try values.decodeIfPresent(String.self, forKey: .lu)
        s = try values.decodeIfPresent(String.self, forKey: .s)
        sc = try values.decodeIfPresent(String.self, forKey: .sc)
    }
    
}
