//
//  TaskDetailsViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine

class TaskDetailsViewModel: ObservableObject {
    
    struct Input {
        let title: AnyPublisher<String, Never>
        let doneButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
        let doneButtonIsEnabled: AnyPublisher<Bool, Never>
        let onClose: AnyPublisher<Void, Never>
    }
    
    private(set) var title: AnyPublisher<String, Never>?
    private(set) var doneButtonIsEnabled: CurrentValueSubject<Bool, Never>
    @Published private(set) var selectedPeriod: Period?
        
    private let task: Task?
    private let repository = TasksRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    init(task: Task? = nil) {
        self.task = task
        self.selectedPeriod = task?.period
        self.doneButtonIsEnabled = .init(false)
    }
    
    func setPeriod(_ period: Period) {
        self.selectedPeriod = period
    }
    
    func transform(input: Input) -> Output {
        let taskPublisher = Publishers.CombineLatest(input.title, $selectedPeriod)
        
        let titleSubject = CurrentValueSubject<String, Never>(task?.title ?? "")
        let doneButtonIsEnabled = taskPublisher
            .map { !$0.isEmpty && $1 != nil }
            .eraseToAnyPublisher()
        
        let onClosePublisher: AnyPublisher<Void, Never> = input.doneButtonDidTap
            .withLatestFrom(taskPublisher)
//            .flatMap { return taskPublisher }
            .map { [weak self] (title, period) in
                guard let `self` = self else { return }
                guard let period = period else { return }
                if let task = self.task {
                    task.period = period
                    task.title = title
                    self.repository.update(task: task)
                } else {
                    let task = Task(
                        title: title,
                        period: period
                    )
                    self.repository.add(task: task)
                }
                return ()
            }
            .eraseToAnyPublisher()
        
        return .init(title: titleSubject.eraseToAnyPublisher(),
                     doneButtonIsEnabled: doneButtonIsEnabled,
                     onClose: onClosePublisher)
    }
}

//
//  Combine+WithLatestFrom.swift
//
//  Created by Shai Mishali on 29/08/2019.
//  Copyright © 2019 Shai Mishali. All rights reserved.
//
import Combine

// MARK: - Operator methods
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
  ///  Merges two publishers into a single publisher by combining each value
  ///  from self with the latest value from the second publisher, if any.
  ///
  ///  - parameter other: Second observable source.
  ///  - parameter resultSelector: Function to invoke for each value from the self combined
  ///                              with the latest value from the second source, if any.
  ///
  ///  - returns: A publisher containing the result of combining each value of the self
  ///             with the latest value from the second publisher, if any, using the
  ///             specified result selector function.
  func withLatestFrom<Other: Publisher, Result>(_ other: Other,
                                                resultSelector: @escaping (Output, Other.Output) -> Result)
      -> Publishers.WithLatestFrom<Self, Other, Result> {
    return .init(upstream: self, second: other, resultSelector: resultSelector)
  }

  ///  Upon an emission from self, emit the latest value from the
  ///  second publisher, if any exists.
  ///
  ///  - parameter other: Second observable source.
  ///
  ///  - returns: A publisher containing the latest value from the second publisher, if any.
  func withLatestFrom<Other: Publisher>(_ other: Other)
      -> Publishers.WithLatestFrom<Self, Other, Other.Output> {
    return .init(upstream: self, second: other) { $1 }
  }
}

// MARK: - Publisher
extension Publishers {
  @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public struct WithLatestFrom<Upstream: Publisher,
                               Other: Publisher,
                               Output>: Publisher where Upstream.Failure == Other.Failure {
    public typealias Failure = Upstream.Failure
    public typealias ResultSelector = (Upstream.Output, Other.Output) -> Output

    private let upstream: Upstream
    private let second: Other
    private let resultSelector: ResultSelector
    private var latestValue: Other.Output?

    init(upstream: Upstream,
         second: Other,
         resultSelector: @escaping ResultSelector) {
      self.upstream = upstream
      self.second = second
      self.resultSelector = resultSelector
    }

    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let sub = Subscription(upstream: upstream,
                             second: second,
                             resultSelector: resultSelector,
                             subscriber: subscriber)
      subscriber.receive(subscription: sub)
    }
  }
}

// MARK: - Subscription
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.WithLatestFrom {
  private class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
    private let subscriber: S
    private let resultSelector: ResultSelector
    private var latestValue: Other.Output?

    private let upstream: Upstream
    private let second: Other

    private var firstSubscription: Cancellable?
    private var secondSubscription: Cancellable?

    init(upstream: Upstream,
         second: Other,
         resultSelector: @escaping ResultSelector,
         subscriber: S) {
      self.upstream = upstream
      self.second = second
      self.subscriber = subscriber
      self.resultSelector = resultSelector
      trackLatestFromSecond()
    }

    func request(_ demand: Subscribers.Demand) {
      // withLatestFrom always takes one latest value from the second
      // observable, so demand doesn't really have a meaning here.
      firstSubscription = upstream
        .sink(
          receiveCompletion: { [subscriber] in subscriber.receive(completion: $0) },
          receiveValue: { [weak self] value in
            guard let self = self else { return }

            guard let latest = self.latestValue else { return }
            _ = self.subscriber.receive(self.resultSelector(value, latest))
        })
    }

    // Create an internal subscription to the `Other` publisher,
    // constantly tracking its latest value
    private func trackLatestFromSecond() {
      let subscriber = AnySubscriber<Other.Output, Other.Failure>(
        receiveSubscription: { [weak self] subscription in
          self?.secondSubscription = subscription
          subscription.request(.unlimited)
        },
        receiveValue: { [weak self] value in
          self?.latestValue = value
          return .unlimited
        },
        receiveCompletion: nil)

      self.second.subscribe(subscriber)
    }

    func cancel() {
      firstSubscription?.cancel()
      secondSubscription?.cancel()
    }
  }
}
