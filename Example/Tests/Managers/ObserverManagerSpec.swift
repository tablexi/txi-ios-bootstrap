//
//  ObserverManagerSpec.swift
//  TXIBootstrap
//
//  Created by Ed Lafoy on 12/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import TXIBootstrap

class ObserverManagerSpec: QuickSpec {
  
  override func spec() {
    var observerManager: ObserverManager!
    
    beforeEach {
      observerManager = ObserverManager()
    }
    
    it("exists") {
      expect(observerManager).toNot(beNil())
    }
    
    it("sends and observes notifications") {
      let value = "hello"
      let notification = Notification<String>()
      var received = ""
      observerManager.observeNotification(notification) { string in
        received = string
      }
      notification.post(value)
      expect(received).to(equal(value))
    }
    
  }
  
}