//
//  EnvironmentManagerSpec.swift
//  TXIBootstrap
//
//  Created by Ed Lafoy on 12/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import TXIBootstrap

class EnvironmentManagerSpec: QuickSpec {
  
  var bundle: Bundle { return Bundle(for: type(of: self)) }
  let userDefaults = UserDefaults(suiteName: "test")!
  let userDefaultsKey = "environment"
  
  var environmentValues: [[String: AnyObject]] {
    let path = self.bundle.path(forResource: "Environments", ofType: "plist")!
    let values = NSArray(contentsOfFile: path) as? [[String: AnyObject]]
    return values ?? []
  }
  
  
  var environmentManager: EnvironmentManager<TestEnvironment>!

  override func spec() {
    beforeEach {
      self.userDefaults.setValue("", forKey: self.userDefaultsKey)
      expect(self.environmentValues.count).to(beGreaterThan(0))
      self.environmentManager = EnvironmentManager<TestEnvironment>(userDefaults: self.userDefaults, bundle: self.bundle)
    }
    
    it("reads environments from Environments.plist") {
      expect(self.environmentManager.environments.count).to(equal(self.environmentValues.count))
    }
    
    it("populates valid environments") {
      self.validateEnvironmentAtIndex(index: 0)
      self.validateEnvironmentAtIndex(index: 1)
    }
    
    it("saves the selected environment in user defaults") {
      let environment1 = self.environmentManager.environments[0]
      let environment2 = self.environmentManager.environments[1]
      
      self.environmentManager.currentEnvironment = environment1
      expect(self.userDefaults.value(forKey: self.userDefaultsKey) as? String).to(equal(environment1.name))
      
      self.environmentManager.currentEnvironment = environment2
      expect(self.userDefaults.value(forKey: self.userDefaultsKey) as? String).to(equal(environment2.name))
    }
    
    it("shows the correct current environment if it's changed elsewhere by another instance of EnvironmentManager") {
      let otherEnvironmentManager = EnvironmentManager<TestEnvironment>(userDefaults: self.userDefaults, bundle: self.bundle)
      
      expect(otherEnvironmentManager.currentEnvironment).to(equal(self.environmentManager.currentEnvironment))
      expect(otherEnvironmentManager.currentEnvironment).to(equal(self.environmentManager.environments[0]))
      
      self.environmentManager.currentEnvironment = self.environmentManager.environments[1]
      expect(otherEnvironmentManager.currentEnvironment).to(equal(self.environmentManager.currentEnvironment))
    }
    
    context("with no stored environment") {
      var defaultEnvironment: TestEnvironment!
      beforeEach {
        self.userDefaults.setValue("", forKey: self.userDefaultsKey)
        self.environmentManager = EnvironmentManager<TestEnvironment>(userDefaults: self.userDefaults, bundle: self.bundle)
        defaultEnvironment = self.environmentManager.environments[0]
      }
      
      it("defaults to first environment") {
        expect(self.environmentManager.currentEnvironment).to(equal(defaultEnvironment))
      }
    }

    context("with saved environment") {
      beforeEach {
        self.userDefaults.setValue("Stage", forKey: self.userDefaultsKey)
        self.environmentManager = EnvironmentManager<TestEnvironment>(userDefaults: self.userDefaults, bundle: self.bundle)
      }
      
      it("uses the saved environment") {
        guard let stageEnvironment = self.environmentManager.environments.filter({ $0.name == "Stage" }).first else { return fail() }
        expect(self.environmentManager.currentEnvironment).to(equal(stageEnvironment))
      }
    }
  }
  
  func validateEnvironmentAtIndex(index: Int) {
    let environment = environmentManager.environments[index]
    let values = environmentValues[index]
    guard let name = values["Name"] as? String,
      let domain = values["Domain"] as? String,
      let key = values["Key"] as? String else { return fail() }
    expect(environment.name).to(equal(name))
    expect(environment.domain).to(equal(domain))
    expect(environment.key).to(equal(key))
  }
}

class TestEnvironment: Environment, CustomDebugStringConvertible {
  
  var name: String = ""
  var domain: String = ""
  var key: String = ""
  
  required init?(environment: [String: AnyObject]) {
    guard let name = environment["Name"] as? String, let domain = environment["Domain"] as? String, let key = environment["Key"] as? String else { return nil }
    self.name = name
    self.domain = domain
    self.key = key
  }
  
  var debugDescription: String { return self.name }
}
func ==(left: TestEnvironment, right: TestEnvironment) -> Bool { return left.name == right.name }
