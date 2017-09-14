//
//  HTTPRequest.swift
//  NetworkAPI
//
//  Created by santosh on 06/09/17.
//  MIT License
/*
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/


import Foundation

extension String {
    /**
     A simple extension to the String object to encode it for web request.
     
     :returns: Encoded version of of string it was called as.
     */
    var escaped: String? {
        var set = CharacterSet()
        set.formUnion(CharacterSet.urlQueryAllowed)
        set.remove(charactersIn: "[].:/?&=;+!@#$()',*\"") // remove the HTTP ones from the set.
        return self.addingPercentEncoding(withAllowedCharacters: set)
    }
    
    
    /**
     A simple extension  which sets complete URL using baseURL and Path
     */
    
    func formatToCompleteURL(_baseURL: String, path:String) -> String {
        return _baseURL + path
    }
    
}


/**
 URLRequest extension which sets header required
 */

extension URLRequest {
    
      mutating func setHeaders(_headers:[String:Any]) {
        
        for (key, value) in _headers {
            self.setValue(value as? String, forHTTPHeaderField: key)
        }
        
    }
}

/**
 Dictionary extension which builds query strings
 */

extension Dictionary {
   
    func queryString() -> String {
        
        var stringValue = ""
        var currentIndex = 0;
        
        for (key, value) in self {
            stringValue =  stringValue + (key as! String) + "=" + (value as! String)
            currentIndex += 1
            
            if currentIndex != self.keys.count {
                stringValue.append("&")
            }
            
        }
        
        return stringValue
    }
}



/**
 The standard HTTP Verbs
 */
public enum HTTPVerb: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
    case UNKNOWN = "UNKNOWN"
}

