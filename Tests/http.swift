//
//  http.swift
//  SwiftHTTPTests
//
//  Created by lcj on 2017/11/29.
//  Copyright © 2017年 Vluxe. All rights reserved.
//

import XCTest
import SwiftHTTP
class http: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    fileprivate struct Topics: Codable {
        var success: Bool?
        var data : [TopicFF]?
    }
    fileprivate struct AuthorFF : Codable{
        var loginname: String?
        var avatar_url: String?
    }
    fileprivate struct TopicFF: Codable {
        var id: String?
        var author_id : String?
        var tab : String?
        var content : String?
        var title : String?
        var last_reply_at : String?
        var good : Int?
        var top : Bool?
        var reply_count : Int?
        var visit_count : Int?
        var create_at : String?
        var author : AuthorFF?
    }
    fileprivate struct PostedResult: Codable {
        var success: Bool?
        var topic_id : String?
    }
    let base = "https://cnodejs.org/api/v1/"
    func testGetRequest() {
        let expectation = self.expectation(description: "testGetRequest")
        
        do {
            let p :[String:Any] = ["page":1,"tab":"all","mdrender":true,"limit":3]
            try HTTP.GET(base + "topics", parameters: p){ response in
                if response.error != nil {
                    print(response.error)
                    XCTAssert(false, "Failure")
                }else{
                    let decoder = JSONDecoder()
                    let topics1 = try! decoder.decode(Topics.self, from: response.data)
                    XCTAssert(topics1.success == true, "Pass")
                }
                
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    func testPostRequest() {
        let expectation = self.expectation(description: "testGetRequest")
        
        do {
            let p :[String:Any] =
                ["accesstoken":"9c7d03d6-11ef-4637-b8d9-2be203140e5c","title":"MYTITLE","tab":"dev","content":"MYCONTENT"]
            try HTTP.POST(base + "topics", parameters: p){ response in
                if response.error != nil {
                    print(response.error)
                    XCTAssert(false, "Failure")
                }else{
                    let decoder = JSONDecoder()
                    let topics1 = try! decoder.decode(PostedResult.self, from: response.data)
                    XCTAssert(topics1.success == true, "Pass")
                }
                
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    fileprivate struct CollectedResult: Codable {
        var success: Bool?
    }
    fileprivate struct CollectedResultError: Codable {
        var success: Bool?
        var error_message : String?
    }
    fileprivate struct CollectedResultSuccess: Codable {
        var success: Bool?
        var data : [CollectedItem]?
    }
    fileprivate struct CollectedItem: Codable {
        var id: String?
    }
    func testGetCollect() {
        let expectation = self.expectation(description: "testGetRequest")
        
        do {
            let p :[String:Any] = [:]
            try HTTP.GET(base + "topic_collect/1000copy", parameters: p){ response in
                if response.error != nil {
                    print(response.error)
                    XCTAssert(false, "Failure")
                }else{
                    let decoder = JSONDecoder()
                    let topics1 = try! decoder.decode(CollectedResult.self, from: response.data)
                    if topics1.success!{
                        let topics2 = try! decoder.decode(CollectedResultSuccess.self, from: response.data)
                        XCTAssert(false, "Failure")
                    }else{
                        let topics2 = try! decoder.decode(CollectedResultError.self, from: response.data)
                        XCTAssert(false, "Failure")
                    }
                    XCTAssert(topics1.success == true, "Pass")
                }
                
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
}
