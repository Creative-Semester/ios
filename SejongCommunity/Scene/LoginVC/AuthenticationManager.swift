//
//  AuthenticationManager.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/08.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
class AuthenticationManager {
    // 사용자 정보 및 토큰을 저장하는 UserDefaults 키
    private static let kAuthTokenKey = "AuthToken"
    private static let krefreshTokenKey = "refreshToken"
    static func saveAuthToken(token: String, refresh: String){
        print("AuthenticationManager.saveAuthToken - called()")
        KeychainWrapper.standard.set(token, forKey: kAuthTokenKey)
        KeychainWrapper.standard.set(refresh, forKey: krefreshTokenKey)
    }
    
    //현재 로그인 상태 확인
    static func isUserLoggedIn() -> Bool {
        print("AuthenticationManager.isUserLoggedIn - called()")
        // UserDefaults에서 저장된 토큰을 가져옵니다.
            if let token = KeychainWrapper.standard.string(forKey: kAuthTokenKey) {
                // 토큰이 있을 경우, 토큰이 유효한지 검사합니다.
                return isTokenValid()
            }
        return false
    }
    static func isTokenValid() -> Bool {
        print("isTokenValid - called()")
        var Expiration = ""
        var Message = ""
        var isValid = true
        //코드가 만료되었는지 확인 -> 리프레시 재발급
        var urlString = "http://15.164.161.53:8082/api/v1/auth/reissue"
        guard let url = URL(string: urlString) else {
                // 유효하지 않은 URL 처리
                return false
            }
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let rfToken = KeychainWrapper.standard.string(forKey: "refreshToken")
        let requestBody : [String : Any] = [
            "accessToken" : acToken,
            "refreshToken" : rfToken
        ]
        var request = URLRequest(url: url)
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []){
            request.httpBody = jsonData
        }
        request.httpMethod = "POST"
        
        // HTTP 요청 헤더 설정 (Content-Type: application/json)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "Authorization")
        //URLSession을 사용하여 서버와 통신
        let task = URLSession.shared.dataTask(with: request) { (data, response,error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    //서버로부터 받은 JSON 데이터 처리
                    print("Response JSON: \(responseJSON)")
                    //토큰이 만료 되었는지 확인
                    print("토큰 유효성 검사 메서드에서의 status - \(responseJSON["status"]), code - \(responseJSON["code"]),  result - \(responseJSON["result"])")
                    if let serverResponseCode = responseJSON["code"] as? String,
                        let message = responseJSON["message"] as? String{
                        Expiration = serverResponseCode
                        Message = message
                        print("토큰 유효성 검사 : \(Expiration), 메시지 : \(message)")
                    }else{
                        print("토큰 유효성 검사 에러 - Invalid JSON response")
                    }
                    //리프레시 토큰이 살아있다면, 새로운 토큰을 받아서 저장해야함.
                    if (Message == "사용자를 찾지 못했습니다" && Expiration == "U001") {
                        //사용자를 찾지 못했을 경우 로그아웃 시켜야함.
                        isValid = false
                        AuthenticationManager.logoutUser()
                    }else if(Expiration == "L003"){ //리프레시 토큰이 죽었다면 로그아웃 시켜야함. 로그인이 false(L003)
                        isValid = false
                        AuthenticationManager.logoutUser()
                    }else if Expiration != "L003"{
                        if let result = responseJSON["result"] as? [String: Any],
                            let accessToken = result["accessToken"] as? String,
                            let refreshToken = result["refreshToken"] as? String{
                            
                                print("refreshToken이 만료되지 않았습니다. 새로운 토큰을 발급받고 저장합니다. accessToken :  \(accessToken), refreshToken : \(refreshToken)")
                                saveAuthToken(token: accessToken, refresh: refreshToken)
                        }else{
                            print("토큰 재발행 에러 - Invalid JSON response")
                        }
                    }
                }else{
                    print("reissue - 통신 에러")
                }
            }
        }
        task.resume() //요청 보내기
        return isValid
    }
    static func logoutUser() {
        print("AuthenticationManager.logoutUser - called()")
        DispatchQueue.main.async {
                // 메인 스레드에서 UI 업데이트 수행
                KeychainWrapper.standard.removeObject(forKey: kAuthTokenKey)
                KeychainWrapper.standard.removeObject(forKey: krefreshTokenKey)
                // 예: 로그인 화면을 다시 표시
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                UIApplication.shared.keyWindow?.rootViewController = navigationController
            }
    }
    // 토큰 유효성 검사
    static func validateToken() {
        if isUserLoggedIn() {
            print("토큰 유효. 계속 로그인 상태 유지")
        }else{
            print("토큰 만료, 로그아웃 처리")
            logoutUser()
        }
    }
}
