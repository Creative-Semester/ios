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
    
    func postOfficeFileUpload(fileURL: URL, fileName: String, completion : @escaping (NetworkResult<Any>) -> Void) {
        
        //토큰 유효성 검사
        guard AuthenticationManager.isTokenValid() else { return }
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken") ?? ""
        let url = "\(APIConstants.fileUploadURL)"
        
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "accessToken" : acToken
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            // 파일 업로드
            multipartFormData.append(fileURL, withName: "file", fileName: fileName, mimeType: "application/octet-stream")
        }, to: url, headers: header)
        .uploadProgress(queue: .main, closure: { progress in
            // 업로드 진행 상황 모니터링
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let resultString = String(data: data, encoding: .utf8) {
                        completion(.success(resultString))
                    } else {
                        completion(.networkFail)
                    }
                } else {
                    completion(.networkFail)
                }
            case .failure(_):
                completion(.networkFail)
            }
        }
        
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(OfficeFileUploadResponse.self, from: data) else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

