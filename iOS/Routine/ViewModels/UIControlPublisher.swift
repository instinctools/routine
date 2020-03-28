//
//  UIControlPublisher.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/28/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine

/// A custom subscription to capture UIControl target events.
final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive((control))
    }
}

/// A custom `Publisher` to work with our custom `UIControlSubscription`.
struct UIControlPublisher<Control: UIControl>: Publisher {

    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}

extension UIBarButtonItem: CombineCompatible { }
extension CombineCompatible where Self: UIBarButtonItem {
    var tap: UIBarButtonPublisher {
        return UIBarButtonPublisher(barButton: self)
    }
}

final class BarButtonItemTarget<SubscriberType: Subscriber, Control: UIBarButtonItem>: Subscription where SubscriberType.Input == Void {
    
    private var subscriber: SubscriberType?
    var barButtonItem: UIBarButtonItem
    
    init(subscriber: SubscriberType, barButtonItem: UIBarButtonItem) {
        self.subscriber = subscriber
        self.barButtonItem = barButtonItem
        barButtonItem.target = self
        barButtonItem.action = #selector(BarButtonItemTarget.action(_:))
    }
    
    func cancel() {
        barButtonItem.target = nil
        barButtonItem.action = nil
    }
    
    @objc func action(_ sender: AnyObject) {
        _ = subscriber?.receive(())
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
}

/// A custom `Publisher` to work with our custom `UIControlSubscription`.
struct UIBarButtonPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Never

    let barButton: UIBarButtonItem

    init(barButton: UIBarButtonItem) {
        self.barButton = barButton
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIBarButtonPublisher.Failure, S.Input == UIBarButtonPublisher.Output {
        let subscription = BarButtonItemTarget<S, UIBarButtonItem>(subscriber: subscriber, barButtonItem: barButton)
        subscriber.receive(subscription: subscription)
    }
}
