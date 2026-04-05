//
//  CustomRoutineViewController.swift
//  FitAlly
//
//  Created by 차지용 on 4/6/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class CustomRoutineViewController: UIViewController, DesiginProtocol {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let dimView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "커스텀 루틴 만들기"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceVertical = true
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        $0.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        $0.setTitle(" 뒤로", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .left // Align to left as per screenshot
    }
    
    // Routine Name
    private let nameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "루틴 이름을 입력하세요", attributes: [.foregroundColor: UIColor.gray])
        $0.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        $0.layer.cornerRadius = 12
        $0.textColor = .white
        $0.setLeftPaddingPoints(15)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(white: 0.25, alpha: 1.0).cgColor
    }
    
    // Exercise Lists
    private let exerciseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private let addExerciseButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.setTitle("+   운동 추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    // Selection Section
    private let selectionView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.08, alpha: 1.0)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "#00D3F3")?.withAlphaComponent(0.2).cgColor
        $0.isHidden = true
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("루틴 저장하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        $0.layer.cornerRadius = 16
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
    
    func configureUI() {
        view.backgroundColor = .clear
    }
    
    func configureHierarchy() {
        view.addSubview(dimView)
        view.addSubview(containerView)
        
        [titleLabel, closeButton, divider, scrollView, saveButton].forEach { containerView.addSubview($0) }
        
        scrollView.addSubview(contentStackView)
        
        [backButton, createSection("루틴 이름", content: nameTextField), createSection("운동 목록", content: exerciseStackView), addExerciseButton, selectionView].forEach { 
            contentStackView.addArrangedSubview($0) 
        }
        
        setupSelectionViewContent()
    }
    
    func configureLayout() {
        dimView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24); make.leading.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel); make.trailing.equalToSuperview().offset(-24); make.size.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16); make.leading.trailing.equalToSuperview(); make.height.equalTo(1)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24); make.leading.trailing.equalToSuperview().inset(24); make.height.equalTo(56)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
            make.width.equalTo(scrollView).offset(-48)
        }
        
        addExerciseButton.snp.makeConstraints { make in make.height.equalTo(48) }
    }
    
    private func createSection(_ title: String, content: UIView) -> UIView {
        let v = UIView()
        let l = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = .white }
        v.addSubview(l); v.addSubview(content)
        l.snp.makeConstraints { make in make.top.leading.equalToSuperview() }
        content.snp.makeConstraints { make in
            make.top.equalTo(l.snp.bottom).offset(12); make.leading.trailing.bottom.equalToSuperview()
            if content is UITextField { make.height.equalTo(50) }
        }
        return v
    }
    
    private func bind() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] in self?.view.window?.rootViewController?.dismiss(animated: true) }).disposed(by: disposeBag)
        backButton.rx.tap.subscribe(onNext: { [weak self] in self?.dismiss(animated: true) }).disposed(by: disposeBag)
        
        addExerciseButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectionView.isHidden = false
            self?.addExerciseButton.isHidden = true
            self?.scrollToBottom()
        }).disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty.map { !$0.isEmpty }.subscribe(onNext: { [weak self] hasText in
            let brandColor = UIColor(named: "#00D3F3") ?? .cyan
            let disabledColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
            self?.saveButton.isEnabled = hasText
            self?.saveButton.backgroundColor = hasText ? brandColor : disabledColor
        }).disposed(by: disposeBag)
    }
    
    private func setupSelectionViewContent() {
        let title = UILabel().then { $0.text = "운동 선택"; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = .white }
        let cancel = UIButton().then { $0.setTitle("취소", for: .normal); $0.setTitleColor(.gray, for: .normal); $0.titleLabel?.font = .systemFont(ofSize: 14) }
        selectionView.addSubview(title); selectionView.addSubview(cancel)
        title.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(20) }
        cancel.snp.makeConstraints { make in make.centerY.equalTo(title); make.trailing.equalToSuperview().offset(-20) }
        
        cancel.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectionView.isHidden = true
            self?.addExerciseButton.isHidden = false
        }).disposed(by: disposeBag)
        
        let gridStack = UIStackView().then { $0.axis = .vertical; $0.spacing = 12 }
        selectionView.addSubview(gridStack)
        gridStack.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20); make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        let exercises = [("벤치 프레스", "가슴", "💪"), ("인클라인 벤치 프레스", "가슴", "💪"), ("딥스", "가슴", "💪"), ("스쿼트", "하체", "🦵"), ("레그 프레스", "하체", "🦵"), ("런지", "하체", "🦵")]
        
        for i in stride(from: 0, to: exercises.count, by: 2) {
            let row = UIStackView().then { $0.axis = .horizontal; $0.spacing = 12; $0.distribution = .fillEqually }
            for j in 0..<2 {
                if i + j < exercises.count {
                    let item = exercises[i + j]
                    let btn = createSelectionItem(name: item.0, part: item.1, emoji: item.2)
                    row.addArrangedSubview(btn)
                    btn.rx.tap.subscribe(onNext: { [weak self] in
                        self?.addExerciseCard(name: item.0, emoji: item.2)
                        self?.selectionView.isHidden = true
                        self?.addExerciseButton.isHidden = false
                    }).disposed(by: disposeBag)
                }
            }
            gridStack.addArrangedSubview(row)
        }
    }
    
    private func createSelectionItem(name: String, part: String, emoji: String) -> UIButton {
        let btn = UIButton().then { $0.backgroundColor = .black; $0.layer.cornerRadius = 12 }
        let eLb = UILabel().then { $0.text = emoji; $0.font = .systemFont(ofSize: 20); $0.isUserInteractionEnabled = false }
        let nLb = UILabel().then { $0.text = name; $0.font = .systemFont(ofSize: 14, weight: .bold); $0.textColor = .white; $0.numberOfLines = 2; $0.textAlignment = .center; $0.isUserInteractionEnabled = false }
        let pLb = UILabel().then { $0.text = part; $0.font = .systemFont(ofSize: 12); $0.textColor = .gray; $0.isUserInteractionEnabled = false }
        [eLb, nLb, pLb].forEach { btn.addSubview($0) }
        eLb.snp.makeConstraints { make in make.top.equalToSuperview().offset(12); make.centerX.equalToSuperview() }
        nLb.snp.makeConstraints { make in make.top.equalTo(eLb.snp.bottom).offset(4); make.leading.trailing.equalToSuperview().inset(8) }
        pLb.snp.makeConstraints { make in make.top.equalTo(nLb.snp.bottom).offset(2); make.centerX.equalToSuperview(); make.bottom.equalToSuperview().offset(-12) }
        btn.snp.makeConstraints { make in make.height.equalTo(100) }
        return btn
    }
    
    private func addExerciseCard(name: String, emoji: String) {
        let card = UIView().then {
            $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0); $0.layer.cornerRadius = 20; $0.layer.borderWidth = 1; $0.layer.borderColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        }
        
        let icon = UILabel().then { $0.text = emoji; $0.font = .systemFont(ofSize: 24) }
        let nameLb = UILabel().then { $0.text = name; $0.font = .systemFont(ofSize: 18, weight: .bold); $0.textColor = .white }
        let infoLb = UILabel().then { $0.text = "3세트 x 10회 • 20kg • 휴식 90초"; $0.font = .systemFont(ofSize: 13); $0.textColor = .gray }
        let delBtn = UIButton().then { $0.setImage(UIImage(systemName: "trash"), for: .normal); $0.tintColor = .red.withAlphaComponent(0.6) }
        
        [icon, nameLb, infoLb, delBtn].forEach { card.addSubview($0) }
        icon.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(20); make.size.equalTo(30) }
        nameLb.snp.makeConstraints { make in make.top.equalTo(icon); make.leading.equalTo(icon.snp.trailing).offset(12) }
        infoLb.snp.makeConstraints { make in make.top.equalTo(nameLb.snp.bottom).offset(4); make.leading.equalTo(nameLb) }
        delBtn.snp.makeConstraints { make in make.top.equalToSuperview().offset(20); make.trailing.equalToSuperview().offset(-20); make.size.equalTo(24) }
        
        let controlStack = UIStackView().then { $0.axis = .vertical; $0.spacing = 12 }
        card.addSubview(controlStack)
        controlStack.snp.makeConstraints { make in
            make.top.equalTo(infoLb.snp.bottom).offset(24); make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        let row1 = UIStackView().then { $0.axis = .horizontal; $0.spacing = 12; $0.distribution = .fillEqually }
        row1.addArrangedSubview(createStepper(title: "세트", initialValue: 3, infoLabel: infoLb))
        row1.addArrangedSubview(createStepper(title: "반복", initialValue: 10, infoLabel: infoLb))
        
        let row2 = UIStackView().then { $0.axis = .horizontal; $0.spacing = 12; $0.distribution = .fillEqually }
        row2.addArrangedSubview(createStepper(title: "무게 (kg)", initialValue: 20, infoLabel: infoLb))
        row2.addArrangedSubview(createStepper(title: "휴식 (초)", initialValue: 90, infoLabel: infoLb))
        
        controlStack.addArrangedSubview(row1); controlStack.addArrangedSubview(row2)
        
        exerciseStackView.addArrangedSubview(card)
        delBtn.rx.tap.subscribe(onNext: { [weak card] in card?.removeFromSuperview() }).disposed(by: disposeBag)
        scrollToBottom()
    }
    
    private func createStepper(title: String, initialValue: Int, infoLabel: UILabel) -> UIView {
        let v = UIView()
        let tLb = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 12); $0.textColor = .gray }
        let bg = UIView().then { $0.backgroundColor = .black; $0.layer.cornerRadius = 12 }
        v.addSubview(tLb); v.addSubview(bg)
        tLb.snp.makeConstraints { make in make.top.leading.equalToSuperview() }
        bg.snp.makeConstraints { make in make.top.equalTo(tLb.snp.bottom).offset(6); make.leading.trailing.bottom.equalToSuperview(); make.height.equalTo(44) }
        
        let minus = UIButton().then { $0.setTitle("-", for: .normal); $0.setTitleColor(.white, for: .normal); $0.titleLabel?.font = .systemFont(ofSize: 20) }
        let valLb = UILabel().then { $0.text = "\(initialValue)"; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = .white }
        let plus = UIButton().then { $0.setTitle("+", for: .normal); $0.setTitleColor(.white, for: .normal); $0.titleLabel?.font = .systemFont(ofSize: 20) }
        
        [minus, valLb, plus].forEach { bg.addSubview($0) }
        minus.snp.makeConstraints { make in make.leading.centerY.equalToSuperview(); make.width.equalTo(40) }
        valLb.snp.makeConstraints { make in make.center.equalToSuperview() }
        plus.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview(); make.width.equalTo(40) }
        
        // Value Logic
        let valueRelay = BehaviorRelay<Int>(value: initialValue)
        
        minus.rx.tap.subscribe(onNext: {
            let newVal = max(0, valueRelay.value - 1)
            valueRelay.accept(newVal)
        }).disposed(by: disposeBag)
        
        plus.rx.tap.subscribe(onNext: {
            let newVal = valueRelay.value + 1
            valueRelay.accept(newVal)
        }).disposed(by: disposeBag)
        
        valueRelay.map { "\($0)" }.bind(to: valLb.rx.text).disposed(by: disposeBag)
        
        return v
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom)
            if bottomOffset.y > 0 {
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
}
