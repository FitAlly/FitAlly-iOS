//
//  NewPasswordViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class NewPasswordViewController: UIViewController, DesiginProtocolBind {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        $0.tintColor = .white
    }
    
    private let iconContainer = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 24
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: "#00D3F3")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "새 비밀번호 설정"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "새로운 비밀번호를 입력해주세요\n8자 이상의 영문, 숫자, 특수문자 조합"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // New Password Section
    private let newPasswordLabel = UILabel().then {
        $0.text = "새 비밀번호"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let newPasswordTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "새 비밀번호를 입력하세요",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.textColor = .white
        $0.isSecureTextEntry = true
        $0.setLeftPaddingPoints(45)
        
        let icon = UIImageView(image: UIImage(named: "rock")).then {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .systemGray
            $0.isUserInteractionEnabled = false
        }
        $0.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    // Confirm Password Section
    private let confirmPasswordLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let confirmPasswordTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 다시 입력하세요",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.textColor = .white
        $0.isSecureTextEntry = true
        $0.setLeftPaddingPoints(45)
        
        let icon = UIImageView(image: UIImage(named: "rock")).then {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .systemGray
            $0.isUserInteractionEnabled = false
        }
        $0.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private let completeButton = UIButton().then {
        $0.setTitle("비밀번호 변경 완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    // MARK: - Protocol Conformity
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureHierarchy() {
        view.addSubview(backButton)
        view.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(newPasswordLabel)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        iconContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
        Observable.combineLatest(
            newPasswordTextField.rx.text.orEmpty,
            confirmPasswordTextField.rx.text.orEmpty
        )
        .map { !$0.isEmpty && !$1.isEmpty && $0 == $1 }
        .subscribe(onNext: { [weak self] isValid in
            let brandColor = UIColor(named: "#00D3F3") ?? .cyan
            let disabledColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
            
            self?.completeButton.isEnabled = isValid
            self?.completeButton.backgroundColor = isValid ? brandColor : disabledColor
            self?.completeButton.setTitleColor(isValid ? .black : .white, for: .normal)
        })
        .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self?.present(loginVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
