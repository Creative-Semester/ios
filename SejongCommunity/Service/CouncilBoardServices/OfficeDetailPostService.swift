//
//  OfficeDetailPostService.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/5/23.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class OfficeDetailPostService {
    
    static let shared = OfficeDetailPostService()
    
    
    func postOfficeDetailPost(officeDetailPostMenu: OfficeDetailPostMenu, completion : @escaping (NetworkResult<Any>) -> Void) {
        
        //토큰 유효성 검사
        guard AuthenticationManager.isTokenValid() else { return }
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken") ?? ""
        let url = "\(APIConstants.OfficeDetailURL)"
        
        let header : HTTPHeaders = [
            "Content-Type" : "application/json",
            "accessToken" : acToken
        ]
        
        let parameters: [String: Any] = [
            "affairFiles": [
                "affairName": officeDetailPostMenu.affairName,
                "affairUrl": officeDetailPostMenu.affairUrl
            ],
            "restMoney": officeDetailPostMenu.restMoney,
            "title": officeDetailPostMenu.title,
            "usedMoney": officeDetailPostMenu.usedMoney
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ dataResponse in
            
            switch dataResponse.result {
                
            case .success:
                
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                
                switch networkResult {
                case .success:
                    completion(networkResult)
                default:
                    completion(networkResult)
                }
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200 : return isVaildData(data: data)
        case 400 : return .pathErr
        case 403 : return .tokenErr
        case 500 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(OfficeDetailPostResponse.self, from: data) else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

