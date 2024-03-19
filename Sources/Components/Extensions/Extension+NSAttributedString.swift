//
//  File.swift
//  
//
//  Created by firdavs on 01.06.2023.
//

import UIKit

public extension NSAttributedString {
    
    func fullRange() -> NSRange {
        let nsString = self.string as NSString
        return nsString.range(of: self.string)
    }
    
    func range(of string: String) -> NSRange {
        let result = self.string as NSString
        return result.range(of: string)
    }
    
    func width(
        width: CGFloat = 100,
        height: CGFloat = 100,
        add: CGFloat = 0
    ) -> CGFloat {
        let size = CGSize(width: width, height: height)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = self.boundingRect(with: size,
                                     options: options,
                                     context: nil)
        return rect.width + add
    }
    
    func height(
        width: CGFloat = 100,
        height: CGFloat = 100,
        add: CGFloat = 0
    ) -> CGFloat {
        let size = CGSize(width: width, height: height)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = self.boundingRect(with: size,
                                     options: options,
                                     context: nil)
        return rect.height + add
    }
}
