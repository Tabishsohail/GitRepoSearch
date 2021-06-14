//
//  GitRepoSearchTests.swift
//  GitRepoSearchTests
//
//  Created by Tabish Sohail on 12/06/2021.
//

import XCTest
@testable import GitRepoSearch

class GitRepoSearchTests: XCTestCase {
    var urlSession: URLSession!
    var listPacket:ApiPacket!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRepoApi() throws {
        
        listPacket = ApiPacket()
        listPacket.urlType = .byLanguage(searchString: "swift", pageNumber: 1)
        listPacket.httpMethod = "GET"
        
        // Set mock data
        let sampleRepoData = RepoInfoModel(name: "awesome-ios", description: "All Swift Repositories", forks: 390, watchers: 489, owner: Owner(login: "", id: 4, avatar_url: "sam", publicRepos: 54))
        let mockData = try JSONEncoder().encode(sampleRepoData)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        
        NetworkHandler.shared.getDatafromNetwork(packet:listPacket) { [self] (result, product) in
            
            guard let ressss = product else {
                wait(for: [expectation], timeout: 1)
                return
            }
            
            XCTAssertEqual(ressss.items[0]?.name, "awesome-ios")
                       expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)

    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


//MARK: URLPROTOCOL
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}
