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
    private static let serverResponseCode = 0
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
                return isTokenValid(token, serverResponseCode)
            }
        return false
    }
    static func isTokenValid(_ token: String, _ serverCode: Int) -> Bool {
        if serverResponseCode == 400 {
            //refresh토큰을 이용해 > AccessToken 새로 발급
            
            return false
        }
        return true
    }
    static func logoutUser() {
        print("AuthenticationManager.logoutUser - called()")
        KeychainWrapper.standard.removeObject(forKey: kAuthTokenKey)
        KeychainWrapper.standard.removeObject(forKey: krefreshTokenKey)
        // 예: 로그인 화면을 다시 표시
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
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
