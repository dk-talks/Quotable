//
//  ImageClient.swift
//  Quotable
//
//  Created by Dinesh Sharma on 29/08/23.
//

import Foundation
import UIKit

class ImageClient {
    
    // methods
    static func addTextToImage(image: UIImage, text: String) -> UIImage? {
        let textColor = UIColor.brown
        let textFont = UIFont(name: "Helvetica-Bold", size: image.size.width/10)!
        print("text font: \(textFont.pointSize)")
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.backgroundColor: UIColor.black
        ]
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let rect = CGRect(x: image.size.width/10, y: image.size.height/10, width: image.size.width*0.9, height: image.size.height*0.9)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
