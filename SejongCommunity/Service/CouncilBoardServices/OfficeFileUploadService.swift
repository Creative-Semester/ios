//
//  OfficeFileUploadService.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/5/23.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class OfficeFileUploadService {
    
    static let shared = OfficeFileUploadService()
    
    func postOfficeFileUpload(fileURL: URL, fileName: String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        guard AuthenticationManager.isTokenValid() else { return }
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken") ?? ""
        let url = "\(APIConstants.fileUploadURL)"
        
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "accessToken" : acToken
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileURL, withName: "files", fileName: fileName, mimeType: "application/vnd.ms-excel")
        }, to: url, method: .post, headers: header)
        .response { dataResponse in
            // 업로드 완료 후의 응답 처리
            switch dataResponse.result {
            case .success:
                
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                
                let networkResult = self.judgeStatus(by: statusCode, value!)
                
                switch networkResult {
                case .success:
                    completion(networkResult)
                default:
                    completion(networkResult)
                }
                
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    print("Multipart Form Data Upload Error: \(underlyingError)")
                } else {
                    print("Multipart Form Data Upload Error: \(error.localizedDescription)")
                }
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
        
        guard let decodedData = try? decoder.decode(OfficeFileUploadResponse.self, from: data) else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}
