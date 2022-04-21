//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import Foundation
public extension String {
    public func urlEncoded() -> String {
        let encodeUrlString = addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    //将编码后的url转换回原始的url
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? ""
    }
}
