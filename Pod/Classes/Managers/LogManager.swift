//
//  LogManager.swift
//  Thinkspan
//
//  Created by Ed Lafoy on 7/27/15.
//  Copyright © 2015 ThinkSpan. All rights reserved.
//

import Foundation
import UIKit

/// This class uses XCodeColors to make the debugger pretty

struct LogManagerNotification {
  static let DidPrint = Notification<String>()
}

struct LogManager {
  
  static let redColor = UIColor(rgba: "#fa2644")
  static let grayColor = UIColor(rgba: "#4D4D4E")
  static let greenColor = UIColor(rgba: "#5fff8c")
  static let blueColor = UIColor(rgba: "#91b1c3")
  static let yellowColor = UIColor(rgba: "#ffc13c")
  
  static let ESCAPE = "\u{001b}["
  
  static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
  static let RESET_BG = ESCAPE + "bg;" // Clear any background color
  static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
  static func logWithColor<T>(color: UIColor, message: T?) {
    var msg = "nil"
    if let message = message {
      msg = "\(message)"
    }
    let final = "\(ESCAPE)\(colorToRGBString(color))\(msg)\(RESET)"
    print(final)
    LogManagerNotification.DidPrint.post(final)
  }

  //creates a string from a color for the debugger format
  static func colorToRGBString(color: UIColor) -> String {
    var red = CGFloat()
    var green = CGFloat()
    var blue = CGFloat()
    var alpha = CGFloat()
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    red *= 255
    green *= 255
    blue *= 255
    let rgbString = "fg\(Int(red)),\(Int(green)),\(Int(blue));" //example: fg255,0,255;
    return rgbString
  }
}

public func logYellow<T>(msg: T?) {
  LogManager.logWithColor(LogManager.yellowColor, message: msg)
}

public func logRed<T>(msg: T?) {
  LogManager.logWithColor(LogManager.redColor, message: msg)
}

public func logGreen<T>(msg: T?) {
  LogManager.logWithColor(LogManager.greenColor, message: msg)
}

public func logGray<T>(msg: T?) {
  LogManager.logWithColor(LogManager.grayColor, message: msg)
}

public func logBlue<T>(msg: T?) {
  LogManager.logWithColor(LogManager.blueColor, message: msg)
}
