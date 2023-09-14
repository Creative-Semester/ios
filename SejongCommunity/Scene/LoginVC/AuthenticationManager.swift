//
//  AuthenticationManager.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/08.
//

import Foundation

class AuthenticationManager {
    // 사용자 정보 및 토큰을 저장하는 UserDefaults 키
    private static let kAuthTokenKey = "AuthToken"
    private static let kTokenExpirationKey = "TokenExpiration"
    
    //로그인 시 토큰 저장
    static func saveAuthToken(token: String, expirationDate: Date){
        print("AuthenticationManager.saveAuthToken - called()")
        UserDefaults.standard.set(token, forKey: kAuthTokenKey)
        UserDefaults.standard.set(expirationDate, forKey: kTokenExpirationKey)
    }
    
    //현재 로그인 상태 확인
    static func isUserLoggedIn() -> Bool {
        print("AuthenticationManager.isUserLoggedIn - called()")
        if let expirationDate = UserDefaults.standard.value(forKey: kTokenExpirationKey) as? Date {
            return Date() < expirationDate
        }
        return false
    }
    //로그아웃 처리
    static func logoutUser() {
        print("AuthenticationManager.logoutUser - called()")
        UserDefaults.standard.removeObject(forKey: kAuthTokenKey)
        UserDefaults.standard.removeObject(forKey: kTokenExpirationKey)
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
