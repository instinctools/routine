//
//  AuthViewModel.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/17/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

final class AuthViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let retryButtonAction: Observable<Void>
    }
    
    struct Output {
        let authStateTitle: Driver<String>
        let retryButtonHidden: Driver<Bool>
        let activityVisible: Driver<Bool>
        let loggedInAction: Driver<Void>
    }
    
    enum State {
        case loading
        case error
        case success
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let state = PublishSubject<State>()
        let loginSubject = PublishSubject<Void>()
        let loggedInAction = PublishSubject<Void>()
        
        input.viewWillAppear.subscribe(onNext: {
            if Auth.auth().currentUser == nil {
                loginSubject.onNext(())
            } else {
                loggedInAction.onNext(())
            }
        })
        .disposed(by: disposeBag)
        
        input.retryButtonAction
            .subscribe(onNext: loginSubject.onNext)
            .disposed(by: disposeBag)

        loginSubject.asObservable()
            .do(onNext: {
                state.onNext(.loading)
            })
            .flatMapLatest { [weak self] in
                return self?.login() ?? Single.just(nil)
            }
            .subscribe(onNext: { (authData) in
                if authData != nil {
                    state.onNext(.success)
                } else {
                    state.onNext(.error)
                }
            })
            .disposed(by: disposeBag)
        
        let retryButtonHidden = PublishSubject<Bool>()
        let authStateTitle = PublishSubject<String>()
        let activityVisible = PublishSubject<Bool>()
        state.subscribe(onNext: { (state) in
            switch state {
            case .error:
                authStateTitle.onNext("An error ocurred!")
                retryButtonHidden.onNext(false)
                activityVisible.onNext(false)
            case .loading:
                authStateTitle.onNext("Setting up account")
                retryButtonHidden.onNext(true)
                activityVisible.onNext(true)
            case .success:
                loggedInAction.onNext(())
            }
        })
        .disposed(by: disposeBag)
        
        return Output(authStateTitle: authStateTitle.asDriver(onErrorJustReturn: ""),
                      retryButtonHidden: retryButtonHidden.asDriver(onErrorJustReturn: false),
                      activityVisible: activityVisible.asDriver(onErrorJustReturn: false),
                      loggedInAction: loggedInAction.asDriver(onErrorJustReturn: ()))
    }
    
    private func login() -> Single<AuthDataResult?> {
        return Single<AuthDataResult?>.create { (single) in
            Auth.auth().signInAnonymously { (authData, error) in
                single(.success(authData))
            }
            return Disposables.create()
        }
    }
}
