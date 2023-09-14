//
//  AuthenticationManager.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/08.
//

import Foundation
import UIKit

class AuthenticationManager {
    // 사용자 정보 및 토큰을 저장하는 UserDefaults 키
    private static let kAuthTokenKey = "AuthToken"
    private static let kTokenExpirationKey = "TokenExpiration"
    private static let serverResponseCode = 0
    
    //로그인 시 토큰 저장
//    static func saveAuthToken(token: String, expirationDate: Date){
//        print("AuthenticationManager.saveAuthToken - called()")
//        UserDefaults.standard.set(token, forKey: kAuthTokenKey)
//        UserDefaults.standard.set(expirationDate, forKey: kTokenExpirationKey)
//    }
    static func saveAuthToken(token: String){
        print("AuthenticationManager.saveAuthToken - called()")
        UserDefaults.standard.set(token, forKey: kAuthTokenKey)
    }
    
    //현재 로그인 상태 확인
    static func isUserLoggedIn() -> Bool {
        print("AuthenticationManager.isUserLoggedIn - called()")
        // UserDefaults에서 저장된 토큰을 가져옵니다.
            if let token = UserDefaults.standard.string(forKey: kAuthTokenKey) {
                // 토큰이 있을 경우, 토큰이 유효한지 검사합니다.
                return isTokenValid(token, serverResponseCode)
            }
        return false
    }
    static func isTokenValid(_ token: String, _ serverCode: Int) -> Bool {
        if serverResponseCode == 400 {
            return false
        }
        return true
    }
    //로그아웃 처리
//    static func logoutUser() {
//        print("AuthenticationManager.logoutUser - called()")
//        UserDefaults.standard.removeObject(forKey: kAuthTokenKey)
//        UserDefaults.standard.removeObject(forKey: kTokenExpirationKey)
//    }
    static func logoutUser() {
        print("AuthenticationManager.logoutUser - called()")
        UserDefaults.standard.removeObject(forKey: kAuthTokenKey)
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
