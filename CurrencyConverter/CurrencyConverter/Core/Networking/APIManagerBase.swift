//
//  APIManagerBase.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import UIKit
import Alamofire


class APIManagerBase: NSObject{
    
    //MARK: - Variables
    var alamoFireManager : Session!
    let baseURL = kBaseURL
    let defaultRequestHeader = HTTPHeaders(["Content-Type": "application/json"])
    let defaultError = NSError(domain: "ACError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    
    //MARK: - Init Methods
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        alamoFireManager = Alamofire.Session(configuration: configuration)
    }
    
    
    //MARK:- Error Handling
    func getErrorFromResponseData(data: Data) -> NSError? {
        do{
            let result = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String,AnyObject>>
            if let message = result?[0]["message"] as? String{
                let error = NSError(domain: "GCError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                return error;
            }
        }catch{
            NSLog("Error: \(error)")
        }
        
        return nil
    }
    
    
    //MARK:- URL Creation
    func URLforRoute(route: String,params:Parameters) -> NSURL? {
        
        if let components: NSURLComponents  = NSURLComponents(string: (kBaseURL+route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params{
                queryItems.append(NSURLQueryItem(name:key,value: value as? String))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            
            return components.url as NSURL?
        }
        return nil;
    }
    
    
    func POSTURLforRoute(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (kBaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    // Pass paramaters same as post request. (But in string)
    func GETURLfor(route:String, parameters: Parameters) -> URL?{
        var queryParameters = ""
        for key in parameters.keys {
            if queryParameters.isEmpty {
                queryParameters =  "?\(key)=\((String(describing: (parameters[key]!))).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
            } else {
                queryParameters +=  "&\(key)=\((String(describing: (parameters[key]!))).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
            }
            queryParameters =  queryParameters.trimmingCharacters(in: .whitespaces)
            
        }
        if let components: NSURLComponents = NSURLComponents(string: (kBaseURL+route+queryParameters)){
            return components.url! as URL
        }
        return nil
    }
    
    
    //MARK: - Server Requests
    func serverRequestWith(route: URL,
                           parameters: Parameters?,
                           requestType:HTTPMethod,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        let alamofireRequest = alamoFireManager.request(route, method: requestType, encoding: JSONEncoding.default, headers: defaultRequestHeader)
        
        
        alamofireRequest.responseJSON{ response in
            guard response.error == nil else{
                
                //FIXME: delete this below function call before creating distribution build
                self.showRequestDetailForFailure(responseObject: response)
                failure(response.error! as NSError)
                return;
            }
            if response.value != nil {
                //FIXME: delete this below function call before creating distribution build
                self.showRequestDetailForSuccess(responseObject: response)
                if let jsonResponse = response.value as? Dictionary<String, AnyObject>{
                    success(jsonResponse)
                } else {
                    success(Dictionary<String, AnyObject>())
                }
            }
        }
        
    }
    
    func serverRequestWith(route: URL,
                           parameters: Parameters?,
                           body:Parameters? = nil,
                           requestType:HTTPMethod,
                           success:@escaping DefaultDataAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
    
        let alamofireRequest = alamoFireManager.request(route, method: requestType,parameters:body, encoding: JSONEncoding.default, headers: defaultRequestHeader)
        //.validate(statusCode: 200..<209)
        
        
        alamofireRequest.responseJSON{ response in
            guard response.error == nil else{
                
                //FIXME: delete this below function call before creating distribution build
                self.showRequestDetailForFailure(responseObject: response)
                failure(response.error! as NSError)
                return;
            }
            if response.value != nil {
                //FIXME: delete this below function call before creating distribution build
                self.showRequestDetailForSuccess(responseObject: response)
                guard let data = response.data else { return }
                success(data)
            }
        }
        
    }
    
    
    
    
    func postRequestWithMultipart(route: URL,
                                  parameters: Parameters,
                                  requestType:HTTPMethod,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        
        let URLSTR : URLRequestConvertible = try! URLRequest(url: route.absoluteString, method: HTTPMethod.post, headers: defaultRequestHeader)
        
        alamoFireManager.upload(multipartFormData: multipartFormData(parameters: parameters), with: URLSTR)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("localizedDescription: \n \(String(describing: progress.localizedDescription))")
            })
            .responseJSON(completionHandler: {  response in
                guard response.error == nil else{
                    
                    //FIXME: delete this below function call before creating distribution build
                    self.showRequestDetailForFailure(responseObject: response)
                    failure(response.error! as NSError)
                    return;
                }
                if response.value != nil {
                    //FIXME: delete this below function call before creating distribution build
                    self.showRequestDetailForSuccess(responseObject: response)
                    if let jsonResponse = response.value as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
            })
    }
    
    
    
    
    fileprivate func multipartFormData(parameters: Parameters) -> MultipartFormData {
        let formData: MultipartFormData = MultipartFormData()
        if let params:[String:AnyObject] = parameters as [String : AnyObject]? {
            for (key , value) in params {
                
                if let data = (value as? Data) {
                    formData.append(data, withName: key, fileName: "\(key).jpeg", mimeType: "image/jpeg")
                } else {
                    formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            return formData
        }
    }
    
    
    func downloadPdf(pdfUrl: String, uniqueName: String, completionHandler:@escaping(String, Bool)->()){
       
        let downloadUrl: String = pdfUrl
       
        let destinationPath: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(uniqueName).pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print(downloadUrl)
       alamoFireManager.download(downloadUrl, to: destinationPath)
            .downloadProgress { progress in

            }
            .responseData { response in
                print("response: \(response)")
                switch response.result{
                case .success:
                    
                    if response.fileURL != nil, let filePath = response.fileURL?.absoluteString {
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    completionHandler("", false)
                    break
                }

        }
    }
    
    // MARK:- Print Result
//    func showErrorMessage(error: Error){
//        print("")
//        switch (error as NSError).code {
//        case -1001:
//            print("Time Out")
//        case -1009:
//            print("No Network")
//        case 4:// Api Call Error
//            print("Bad Request")
//        case -1005:
//            print("No Network")
//        default:
//            print((error as NSError).localizedDescription)
//        }
//    }
    
    
    func showRequestDetailForSuccess(responseObject response : AFDataResponse<Any>) {
        
        #if DEBUG
        print("\n\n\n📲📲📲📲📲 ------- Success Response Start ------- 📲📲📲📲📲\n")
        print(""+(response.request?.url?.absoluteString ?? ""))
        print("\n=========   allHTTPHeaderFields   ========== \n")
        print("%@",response.request!.allHTTPHeaderFields!)
        print("\n=========   Request Type   ========== \n")
        print("%@",response.request?.httpMethod?.description ?? "")
        if let bodyData : Data = response.request?.httpBody {
            let bodyString = String(data: bodyData, encoding: String.Encoding.utf8)
            print("\n=========   Request httpBody   ========== \n" + (bodyString ?? ""))
        } else {
            print("\n=========   Request httpBody   ========== \n" + "Found Request Body Nil")
        }
        
        if let responseData : Data = response.data {
            let responseString = String(data: responseData, encoding: String.Encoding.utf8)
            print("\n=========   Response Body   ========== \n" + (responseString ?? ""))
        } else {
            print("\n=========   Response Body   ========== \n" + "Found Response Body Nil")
        }
        print("\n=========   Status Code  ========== \n" + (response.response?.statusCode.description ?? ""))
        print("\n📲📲📲📲📲 ------- Success Response End ------- 📲📲📲📲📲\n\n\n")
        
        #endif
    }
    
    func showRequestDetailForFailure(responseObject response : AFDataResponse<Any>) {
        
        #if DEBUG
        print("\n\n\n📵📵📵📵📵 ------- Failure Response Start ------- 📵📵📵📵📵\n")
        print(""+(response.request?.url?.absoluteString ?? ""))
        print("\n=========   allHTTPHeaderFields   ========== \n")
        print("%@",response.request?.allHTTPHeaderFields ?? ["":""])
        print("\n=========   Request Type   ========== \n")
        print("%@",response.request?.httpMethod?.description ?? "")
        if let bodyData : Data = response.request?.httpBody {
            let bodyString = String(data: bodyData, encoding: String.Encoding.utf8)
            print("\n=========   Request httpBody   ========== \n" + (bodyString ?? ""))
        } else {
            print("\n=========   Request httpBody   ========== \n" + "Found Request Body Nil")
        }
        
        if let responseData : Data = response.data {
            let responseString = String(data: responseData, encoding: String.Encoding.utf8)
            print("\n=========   Response Body   ========== \n" + (responseString ?? ""))
        } else {
            print("\n=========   Response Body   ========== \n" + "Found Response Body Nil")
        }
        
        print("\n=========   Status Code  ========== \n" + (response.response?.statusCode.description ?? ""))
        print("\n=========   Error Description  ========== \n" + (response.error?.errorDescription ?? ""))
        print("\n=========   Error  ========== \n" + (response.error.debugDescription))
        print("\n📵📵📵📵📵 ------- Failure Response End ------- 📵📵📵📵📵\n\n\n")
        
        #endif
    }
    
    
    
}

public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
}
