//
//  WriteOfficeDetailsViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/19.
//

import UIKit
import SnapKit

class WriteOfficeDetailsViewController: UIViewController {

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "학생회 사무내역"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "제목"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "제목"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .black
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let usedAmoutLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "사용 금액"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let usedAmountTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 필드의 스타일 설정
        textField.borderStyle = .roundedRect // 테두리 스타일
        textField.placeholder = "사용 금액" // 플레이스홀더 텍스트
        textField.keyboardType = .decimalPad // 숫자 입력용 키보드
        
        // 금액 입력 시 패딩을 줄 수 있습니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let remainingAmoutLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "남은 금액"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let remainingAmountTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 필드의 스타일 설정
        textField.borderStyle = .roundedRect // 테두리 스타일
        textField.placeholder = "남은 금액" // 플레이스홀더 텍스트
        textField.keyboardType = .decimalPad // 숫자 입력용 키보드
        
        // 금액 입력 시 패딩을 줄 수 있습니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let fileUploadLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "파일 업로드"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let fileUploadButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("엑셀파일 업로드하기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fileUploadButton.addTarget(self, action: #selector(fileUploadButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonButtonTapped), for: .touchUpInside)
        
        setupKeyboardDismissRecognizer()
        setupLayout()
    }
    
    @objc func fileUploadButtonTapped() {
        // 파일 선택 기능 실행
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.spreadsheetml.sheet"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    //화면의 다른 곳을 클릭했을 때 키보드가 내려가게 합니다.
    private func setupKeyboardDismissRecognizer() {
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
       view.endEditing(true)
    }
    
    @objc func completeButtonButtonTapped() {
        //저장하는 통신 코드 추가해야합니다.
        navigationController?.popViewController(animated: true)
    }
    
    func setupLayout() {
        view.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.width.equalTo(30)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.leading.equalTo(userImageView.snp.trailing).offset(12)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(70)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.equalTo(16)
        }
        
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        view.addSubview(usedAmoutLabel)
        usedAmoutLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.equalTo(16)
        }
        
        view.addSubview(usedAmountTextField)
        usedAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(usedAmoutLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        view.addSubview(remainingAmoutLabel)
        remainingAmoutLabel.snp.makeConstraints { make in
            make.top.equalTo(usedAmountTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.equalTo(16)
        }
        
        view.addSubview(remainingAmountTextField)
        remainingAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(remainingAmoutLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        view.addSubview(fileUploadLabel)
        fileUploadLabel.snp.makeConstraints { make in
            make.top.equalTo(remainingAmountTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.equalTo(16)
        }
        
        view.addSubview(fileUploadButton)
        fileUploadButton.snp.makeConstraints { make in
            make.top.equalTo(fileUploadLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(30)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}

extension WriteOfficeDetailsViewController: UIDocumentPickerDelegate {
    // 파일 선택 완료 시 호출되는 메서드
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedFileURL = urls.first {
            // 선택한 파일을 사용하거나 업로드할 수 있음
            print("선택한 파일 경로: \(selectedFileURL)")
            fileUploadButton.setTitle("\(selectedFileURL)", for: .normal)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // 파일 선택이 취소된 경우 처리
        print("파일 선택이 취소되었습니다.")
    }
}
