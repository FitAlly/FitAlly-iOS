//
//  JoinViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class JoinViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        $0.tintColor = .white
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 24
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "일반 회원가입"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .white
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "정보를 입력하여 계정을 만들어주세요"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemGray
    }
    
    private let profileImageContainer = UIView().then {
        $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        $0.layer.cornerRadius = 40
        
        let uploadIcon = UIImageView(image: UIImage(systemName: "square.and.arrow.up")).then {
            $0.tintColor = .systemGray
            $0.contentMode = .scaleAspectFit
        }
        $0.addSubview(uploadIcon)
        uploadIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private let profileUploadButton = UIButton().then {
        $0.setTitle("프로필 이미지 업로드", for: .normal)
        $0.setTitleColor(UIColor(named: "#00D3F3"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    // MARK: - Input Fields
    private func createLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = .systemFont(ofSize: 13, weight: .bold)
            $0.textColor = .white
        }
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        return UITextField().then {
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.systemGray]
            )
            $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
            $0.layer.cornerRadius = 12
            $0.textColor = .white
            $0.setLeftPaddingPoints(15)
            $0.font = .systemFont(ofSize: 14)
        }
    }
    
    private lazy var nicknameLabel = createLabel(text: "닉네임")
    private lazy var nicknameTextField = createTextField(placeholder: "닉네임을 입력하세요")
    
    private lazy var birthLabel = createLabel(text: "생년월일")
    private lazy var birthTextField = createTextField(placeholder: "날짜를 선택하세요").then {
        $0.delegate = self
    }
    
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private lazy var phoneLabel = createLabel(text: "휴대폰 번호")
    private lazy var phoneTextField = createTextField(placeholder: "휴대폰 번호를 입력하세요").then {
        $0.keyboardType = .numberPad
    }
    private let adultVerifyButton = UIButton().then {
        $0.setTitle("성인인증", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    private lazy var emailLabel = createLabel(text: "이메일")
    private lazy var emailTextField = createTextField(placeholder: "example@email.com")
    private let verifyButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    private lazy var passwordLabel = createLabel(text: "비밀번호")
    private lazy var passwordTextField = createTextField(placeholder: "비밀번호를 입력하세요").then {
        $0.isSecureTextEntry = true
    }
    
    private lazy var confirmPasswordLabel = createLabel(text: "비밀번호 재확인")
    private lazy var confirmPasswordTextField = createTextField(placeholder: "비밀번호를 다시 입력하세요").then {
        $0.isSecureTextEntry = true
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(profileImageContainer)
        containerView.addSubview(profileUploadButton)
        
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(nicknameTextField)
        containerView.addSubview(birthLabel)
        containerView.addSubview(birthTextField)
        
        containerView.addSubview(phoneLabel)
        containerView.addSubview(phoneTextField)
        containerView.addSubview(adultVerifyButton)
        
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(verifyButton)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(confirmPasswordLabel)
        containerView.addSubview(confirmPasswordTextField)
        containerView.addSubview(nextButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        profileImageContainer.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        profileUploadButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageContainer.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileUploadButton.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        
        birthLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        birthTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(birthTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        adultVerifyButton.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(70)
            make.height.equalTo(42)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(adultVerifyButton)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(adultVerifyButton.snp.leading).offset(-10)
            make.height.equalTo(42)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(65)
            make.height.equalTo(42)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(verifyButton)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(verifyButton.snp.leading).offset(-10)
            make.height.equalTo(42)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30) // Important for scrollView height
        }
    }
    
    private func setupDatePicker() {
        birthTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(donePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        birthTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = formatter.string(from: datePicker.date)
        birthTextField.resignFirstResponder()
    }
    
    private func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let purposeVC = PurposeViewController()
                purposeVC.modalPresentationStyle = .fullScreen
                self?.present(purposeVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension JoinViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthTextField {
            return false // Prevent typing in birthTextField
        }
        return true
    }
}
