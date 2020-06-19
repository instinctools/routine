//
//  AuthViewController.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/17/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private extension UIColor {
    static var primaryColor: UIColor {
        return UIColor(red: 131/255, green: 93/255, blue: 81/255, alpha: 1.0)
    }
    static var secondaryColor: UIColor {
        return UIColor(red: 188/255, green: 168/255, blue: 154/255, alpha: 1.0)
    }
}

final class AuthViewController: UIViewController {
    
    private lazy var appImageView: UIImageView = {
        let image = UIImage(named: "icon")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var authStateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .medium)
        label.textColor = .primaryColor
        return label
    }()
    
    private lazy var activityIndicatorView: ActivityIndicatorView = {
        let activityIndicator = ActivityIndicatorView()
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.layer.cornerRadius = 8.0
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        return button
    }()
    
    private let viewModel: AuthViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        activityIndicatorView.primaryColor = .primaryColor
        activityIndicatorView.secondaryColor = .secondaryColor
    }
    
    private func setupLayout() {
        view.addSubview(appImageView)
        view.addSubview(authStateLabel)
        view.addSubview(activityIndicatorView)
        view.addSubview(retryButton)
        
        appImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(appImageView.snp.width)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        authStateLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalTo(appImageView.snp.bottom).inset(-50)
        }
        
        let inset = -36.0
        activityIndicatorView.snp.makeConstraints { (make) in
            make.top.equalTo(authStateLabel.snp.bottom).inset(inset)
            make.centerX.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(activityIndicatorView.snp.width)
        }
        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.top.equalTo(authStateLabel.snp.bottom).inset(inset)
        }
    }
    
    private func bindViewModel() {
        let input = AuthViewModel.Input(viewWillAppear: rx.viewWillAppear.asObservable(),
                                        retryButtonAction: retryButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.activityVisible
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.retryButtonHidden
            .drive(retryButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.authStateTitle
            .drive(authStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loggedInAction
            .drive(onNext: { [weak self] in
                self?.showTaskList()
            })
            .disposed(by: disposeBag)
    }
    
    private func showTaskList() {
        let viewModel = TaskListViewModel()
        let viewController = TaskListViewController(viewModel: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.navigationBar.backgroundColor = .systemBackground
        rootViewController.navigationBar.prefersLargeTitles = true
        UIApplication.shared.windows.first?.rootViewController = rootViewController
    }
}
