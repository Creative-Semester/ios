//
//  WriteOfficeDetailsViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/19.
//

import UIKit
import SnapKit
import MobileCoreServices

class WriteOfficeDetailsViewController: UIViewController {

    var officeDetailPostMenu = OfficeDetailPostMenu(
        affairName: "미입력",
        affairUrl: "미입력",
        restMoney: "미입력",
        title: "미입력",
        usedMoney: "미입력"
    )
    
    private var fileName: String?
    
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
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "학생회 사무내역"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "제목"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: placeholderAttributes)

        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let usedAmoutLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "사용 금액"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let usedAmountTextField: UITextField = {
        let textField = UITextField()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "사용 금액", attributes: placeholderAttributes)
        textField.borderStyle = .roundedRect // 테두리 스타일
        textField.keyboardType = .decimalPad // 숫자 입력용 키보드
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.textColor = .black
        // 금액 입력 시 패딩을 줄 수 있습니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let remainingAmoutLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "남은 금액"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let remainingAmountTextField: UITextField = {
        let textField = UITextField()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "남은 금액", attributes: placeholderAttributes)
        textField.borderStyle = .roundedRect // 테두리 스타일
        textField.keyboardType = .decimalPad // 숫자 입력용 키보드
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.textColor = .black
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
    
    private let fileDeleteButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "x.square")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal), for: .normal)
        button.isUserInteractionEnabled = false
        button.isHidden = true
        
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
        fileDeleteButton.addTarget(self, action: #selector(fileDeleteButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        setupKeyboardDismissRecognizer()
        setupLayout()
    }
    
    @objc func fileUploadButtonTapped() {
        // 파일 선택 기능 실행
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
        fileUploadButton.isUserInteractionEnabled = false
    }
    
    @objc func fileDeleteButtonTapped() {
        fileDeleteButton.isUserInteractionEnabled = false
        fileUploadButton.isUserInteractionEnabled = true
        fileDeleteButton.isHidden = true
        fileUploadButton.setTitle("엑셀파일 업로드하기", for: .normal)
        deleteOfficeDetailFile()
    }

    //화면의 다른 곳을 클릭했을 때 키보드가 내려가게 합니다.
    private func setupKeyboardDismissRecognizer() {
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
       view.endEditing(true)
    }
    
    @objc func completeButtonTapped() {
        if let text = titleTextField.text {
            officeDetailPostMenu.title = text
        }
        
        if let text = usedAmountTextField.text {
            officeDetailPostMenu.usedMoney = text
        }
        
        if let text = remainingAmountTextField.text {
            officeDetailPostMenu.restMoney = text
        }
        
        if officeDetailPostMenu.title == "" {
            let alertController = UIAlertController(title: "알림", message: "제목을 작성해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if officeDetailPostMenu.usedMoney == "" {
            let alertController = UIAlertController(title: "알림", message: "사용 금액을 작성해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if officeDetailPostMenu.restMoney == "" {
            let alertController = UIAlertController(title: "알림", message: "남은 금액을 작성해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if officeDetailPostMenu.affairName == "미입력" {
            let alertController = UIAlertController(title: "알림", message: "파일을 첨부해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            postOfficeDetailData()
            
            let alertController = UIAlertController(title: "알림", message: "저장되었습니다", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func postOfficeDetailData() {
        OfficeDetailPostService.shared.postOfficeDetailPost(officeDetailPostMenu: officeDetailPostMenu) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? OfficeDetailPostResponse else { return }
                
                // 실패할 경우에 분기처리는 아래와 같이 합니다.
            case .pathErr :
                print("잘못된 파라미터가 있습니다.")
            case .serverErr :
                print("서버에러가 발생했습니다.")
            default:
                print("networkFail")
            }
        }
    }
    
    func OfficeDetailFileUpload(selectedFileURL: URL, fileName: String) {
        OfficeFileUploadService.shared.postOfficeFileUpload(fileURL: selectedFileURL, fileName: fileName) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? OfficeFileUploadResponse else { return }
                self.fileName = infoData.result[0].fileName
                self.officeDetailPostMenu.affairName = infoData.result[0].fileName
                self.officeDetailPostMenu.affairUrl = infoData.result[0].fileUrl
                // 실패할 경우에 분기처리는 아래와 같이 합니다.
            case .pathErr :
                print("잘못된 파라미터가 있습니다.")
            case .serverErr :
                print("서버에러가 발생했습니다.")
            default:
                print("networkFail")
            }
        }
    }
    
    func deleteOfficeDetailFile() {
        guard let fileName = fileName else { return }
        OfficeFileDeleteService.shared.deleteOfficeDetailFile(fileName: fileName) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? OfficeFileDeleteResponse else { return }
                print(infoData.message)
                // 실패할 경우에 분기처리는 아래와 같이 합니다.
            case .pathErr :
                print("잘못된 파라미터가 있습니다.")
            case .serverErr :
                print("서버에러가 발생했습니다.")
            default:
                print("networkFail")
            }
        }
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
            make.top.equalTo(userNameLabel.snp.bottom).offset(60)
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
        
        view.addSubview(fileDeleteButton)
        fileDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(fileUploadButton.snp.centerY)
            make.trailing.equalTo(fileUploadButton.snp.trailing).inset(24)
            make.width.height.equalTo(44)
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
            fileUploadButton.setTitle("\(selectedFileURL)", for: .normal)
            
            let fileName = selectedFileURL.lastPathComponent
            fileUploadButton.setTitle(fileName, for: .normal)
            
            OfficeDetailFileUpload(selectedFileURL: selectedFileURL, fileName: fileName)
        }
        fileDeleteButton.isUserInteractionEnabled = true
        fileDeleteButton.isHidden = false
    }
    
}
