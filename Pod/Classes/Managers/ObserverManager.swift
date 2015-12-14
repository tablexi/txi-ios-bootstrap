//
//  TypedNotifications.swift
//  Thinkspan
//
//  Created by Daniel Hodos on 7/3/15.
//  Copyright © 2015 ThinkSpan. All rights reserved.

import Foundation

/// A value object that provides a strongly-typed conceptualization of a Notification.
///
/// This uses a generic (A) to hold reference to the payload that is being notified.
/// This payload can be:
///
/// - a type, e.g. `Notification<String>`, `Notification<SomeCustomStruct>`, etc.
/// - a tuple, for when there's multiple pieces to the payload, e.g. `Notification<(index: Int, name: String?)>`
/// - `Notificatin<Void>`, for when there's no payload data
/// - etc.
public struct Notification<A> {
  
  public init() {} 
  
  /// The name of the notification; we generate a random UUID here, since the Notification
  /// object's identity alone can be used for uniqueness.
  let name = NSUUID().UUIDString
  
  /// Posts this notification with the given payload, from the given object.
  ///
  /// - Parameters:
  ///   - value: A payload (defined when the Notification is initialized).
  ///   - object: An optional object that is posting this Notification; often this is nil.
  public func post(value: A, fromObject object: AnyObject?) {
    let userInfo = ["value": Box(value)]
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
  }
  
  /// Posts this notification with the given payload, but not from any specific object.
  ///
  /// - Parameters:
  ///   - value: A payload (defined when the Notification is initialized).
  public func post(value: A) {
    post(value, fromObject: nil)
  }
}

/// A class that provides a way to observe our strongly-typed Notifications via NSNotificationCenter,
/// while also automatically cleaning up after themselves (when this object is deinitialized, it removes
/// the observer that was added to the notification center).
class NotificationObserver {
  
  /// When calling addObserverForName, NSNotificationCenter returns some sort of opaque object.
  /// We don't care what it is, we just need a reference to it so that we can remove it from the
  /// NSNotificationCenter when this object goes out of scope.
  private let observer: NSObjectProtocol
  
  /// Observes a given notification from a given optional Object.
  ///
  /// Parameters:
  ///   - notification: a Notification object
  ///   - object: an optional Object; if nil is passed, then the object that posts the notification will not matter.
  ///   - block: a closure that gets called with the Notification's payload
  init<A>(_ notification: Notification<A>, fromObject object: AnyObject?, block aBlock: A -> ()) {
    observer = NSNotificationCenter.defaultCenter().addObserverForName(notification.name, object: object, queue: nil) { note in
      if let value = (note.userInfo?["value"] as? Box<A>)?.unbox {
        aBlock(value)
      } else {
        assert(false, "Couldn't understand user info")
      }
    }
  }
  
  /// Observes a given notification.
  ///
  /// Parameters:
  ///   - notification: a Notification object
  ///   - block: a closure that gets called with the Notification's payload
  convenience init<A>(_ notification: Notification<A>, block aBlock: A -> ()) {
    self.init(notification, fromObject: nil, block: aBlock)
  }
  
  /// When this object goes out of scope, it will remove the observer from the notification
  /// center, i.e. it will clean up after itself.
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
}

public class ObserverManager {
  var observers = Array<NotificationObserver>()
  
  public init(){}
  
  public func observeNotification<A>(notification: Notification<A>, block aBlock: A -> ()) {
    observeNotification(notification, fromObject: nil, block: aBlock)
  }
  
  public func observeNotification<A>(notification: Notification<A>, fromObject object: AnyObject?, block aBlock: A -> ()) {
    let newObserver = NotificationObserver(notification, fromObject: object, block: aBlock)
    self.observers.append(newObserver)
  }
}

/// Boxing allows for wrapping a value type (e.g. any sort of struct) in a reference type (i.e. a class).
final private class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}
