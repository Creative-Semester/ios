//
//  APIContants.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/02.
//

import Foundation

struct APIConstants {
    // Base URL
    static let baseURL = "http://15.164.161.53:8082"
    
    // Feature URL
    
    //학생회의 정보를 조회하는 api
    static let councilInfoURL = baseURL + "/api/v1/council/info"
    
    //부서별 공약의 이행률을 조회하는 api
    static let PromisesPercentageURL = baseURL + "/api/v1/department/promises/percentage"
    
    //학생회에 존재하는 부서목록 조회 api
    static let departmentURL = baseURL + "/api/v1/department"
    
    //학생회 공약 이행 체크 api
    static let promiseCheckURL = baseURL + "/api/v1/promise"
}
