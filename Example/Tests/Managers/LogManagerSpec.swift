//
//  LogManagerSpec.swift
//  TXIBootstrap
//
//  Created by Ed Lafoy on 12/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import TXIBootstrap

class LogManagerSpec: QuickSpec {
  
  override func spec() {
    
    it("prints logs") {
      logYellow(msg: "hello")
      logRed(msg: "hello")
      logBlue(msg: "hello")
      logGreen(msg: "hello")
      logGray(msg: "hello")
    }
    
  }
  
}
