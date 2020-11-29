//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Muneeb Ali on 19/11/2020.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
    }
    
    func testRateModel() {
        let rateListModel = RateListModel(success: true,
                                          terms: "https://currencylayer.com/terms",
                                          privacy: "https://currencylayer.com/privacy",
                                          timestamp: 1606408864,
                                          source: "USD",
                                          quotes: ["USDAED": 3.673203,
                                                   "USDAFN": 76.932772,
                                                   "USDALL": 104.063388],
                                          error: ResponceError(code: 0, type: "", info: ""))
        
        XCTAssertNotNil(rateListModel)
        XCTAssertEqual(rateListModel.success, true)
        XCTAssertEqual(rateListModel.terms, "https://currencylayer.com/terms")
        XCTAssertEqual(rateListModel.privacy, "https://currencylayer.com/privacy")
        XCTAssertEqual(rateListModel.timestamp, 1606408864)
        XCTAssertEqual(rateListModel.source, "USD")
        XCTAssertEqual(rateListModel.quotes, ["USDAED": 3.673203,
                                              "USDAFN": 76.932772,
                                              "USDALL": 104.063388])
    }
    
    
    func testCountryModel() {
        let countryListModel = CountriesListModel(success: true,
                                                  terms: "https://currencylayer.com/terms",
                                                  privacy: "https://currencylayer.com/privacy",
                                                  currencies: ["AED": "United Arab Emirates Dirham",
                                                               "AFN": "Afghan Afghani",
                                                               "ALL": "Albanian Lek"],
                                                  error: ResponceError(code: 0, type: "", info: ""))
        
        XCTAssertNotNil(countryListModel)
        XCTAssertEqual(countryListModel.success, true)
        XCTAssertEqual(countryListModel.terms, "https://currencylayer.com/terms")
        XCTAssertEqual(countryListModel.privacy, "https://currencylayer.com/privacy")
        XCTAssertEqual(countryListModel.currencies, ["AED": "United Arab Emirates Dirham",
                                                     "AFN": "Afghan Afghani",
                                                     "ALL": "Albanian Lek"])
    }
    
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
}
