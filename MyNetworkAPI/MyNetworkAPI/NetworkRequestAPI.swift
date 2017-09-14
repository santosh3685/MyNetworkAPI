//
//  NetworkRequestAPI.swift
//  NetworkRequestAPI
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

public class NetworkRequestAPI {
    
    public init() {
        
    }
    
    /// Function to be called to make network HTTP request.
    /// - parameter: requestMethod The HTTP request method of the receiver
    /// - parameter: urlString  Url of the receiver
    /// - parameter: timeoutInterval The timeout interval for the request
    /// - parameter: requestPayload The request payload is in the form of dictionary . Payload contains data like query params , header data , post body etc
    
    /* - parameter: completion block , block returns
    
            - dict:  which has all the header fields
            - Any: Error
            - Any: Response Object
            - Bool: true = indicates operation sucess , false = indicates operation is failed
 
    */
    
    public func makeDataTaskRequest(_requestMethod:String, urlString:String,timeoutInterval:Double,requestPayload:[String:Any]!, onCompletion: @escaping ([String:Any]?, Any?,Any?, Bool?) -> Void) {
        
        
        var completeURL = urlString
        
        //---- appends query params to URL if any ----//
        if let params = requestPayload["params"] as! [String:Any]! {
            
            if params.keys.count > 0  {
                completeURL.append("?")
                completeURL.append(params.queryString())
            }
        }
        
        
        let url = URL(string:completeURL)
        
        if let usableUrl = url {
            
            var request = URLRequest(url: usableUrl)
            request.httpMethod = _requestMethod
            request.timeoutInterval = timeoutInterval
            
            //---- set header fields if present ----//
            if let headers = requestPayload["headers"] as! [String:Any]! {
                
                if headers.keys.count > 0  {
                    request.setHeaders(_headers: headers)
                }
            }
            
            //---- set post body if present ----//
            
            if let postBody = requestPayload["postBody"]{
                
                if let postDict = postBody as? [String: Any] {
                    
                    // Post body is an Dictionary in the form of JSON
                    
                    if postDict.keys.count > 0 { // count dictionary keys
                        let jsonData = try! JSONSerialization.data(withJSONObject: postDict, options: [])
                        request.httpBody = jsonData
                    }
                }
                    
                else if let postString = postBody as? String{
                    
                    // Post body is an String
                    
                    if postString.characters.count > 0 { // count characters
                        let stringData =  postString.data(using: .utf8)
                        request.httpBody = stringData
                    }
                        
                    else if let postData = postBody as? Data{
                        
                        // Post body is an Data
                        
                        if postData.count > 0 { // count number of bytes
                            request.httpBody = postData
                        }
                    }
                    
                }
                
                
            }
            
            //---- set post body end ----//
            
            
            
            //----create session to make request----//
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                //----check for Any errors----//
                guard error == nil else {
                    
                    
                    onCompletion(nil, (NetworkExceptionClass.exceptionFor(error: error!)) as Any , nil,false)
                    return
                }
                
                //----check for data received----//
                guard let responseData = data else {
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        var userInfo = [String:Any]()
                        userInfo[NSLocalizedDescriptionKey] = "No Data Received"
                        let  err  = NSError(domain: "No Data", code: 3435, userInfo: userInfo)
                        
                        if httpResponse.statusCode == 200 {
                            
                            onCompletion(httpResponse.allHeaderFields as? [String : Any], (NetworkExceptionClass.exceptionFor(error: err)) as Any, nil,true)
                            return
                            
                        }
                        
                        onCompletion(nil, (NetworkExceptionClass.exceptionFor(error: err)) as Any, nil,false)
                        
                        return
                        
                        
                    }
                    return
                }
                // All is fine , send received data to handler
                onCompletion((response as? HTTPURLResponse)?.allHeaderFields as? [String : Any],nil, responseData,true)
                return
                
            })
            task.resume()
        }
    }
    
    
}
