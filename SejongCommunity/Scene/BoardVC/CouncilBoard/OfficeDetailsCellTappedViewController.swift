//
//  OfficeDetailsCellTappedViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/08.
//

import UIKit
import SnapKit

class OfficeDetailsCellTappedViewController: UIViewController {
    
    var officeDetailList: OfficeDetailList?
    var time: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "해지기전 행사 사무내역"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "23-07-24"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let usedAmountLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)//임시로 추가
        label.textColor = .red
        label.textAlignment = .left
        label.text = "사용 금액 : 213,300원"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let remainingAountLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "남은 금액 : 21,321,750원"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        downloadButton.addTarget(self, action: #selector(downloadFile), for: .touchUpInside)
        
        setupNavigation()
        setupLayout()
        setupConfigure()
    }
    
    func setupNavigation() {
        if let role = UserDefaults.standard.string(forKey: "role") {
            if role == "ROLE_COUNCIL" {
                let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showPopup))
                    navigationItem.rightBarButtonItem = editButton
            }
        }
    }
    
    func setupConfigure() {
        guard let officeDetailList = officeDetailList else { return }
        guard let time = time else { return }
        titleLabel.text = officeDetailList.title
        dateLabel.text = time
        usedAmountLabel.text = "사용 금액 : " + officeDetailList.usedMoney + "원"
        remainingAountLabel.text = "남은 금액 : " + officeDetailList.restMoney + "원"
        let fileTitle: String = "\"\(officeDetailList.fileInfo.fileName)\" 파일 다운로드"
        downloadButton.setTitle(fileTitle, for: .normal)
    }
    
    @objc func downloadFile() {
        // 파일 다운로드 URL 또는 경로 설정
        guard let officeDetailList = officeDetailList,
              let fileURL = URL(string: officeDetailList.fileInfo.fileUrl) else {
            print("Invalid file URL")
            return
        }
        
        URLSession.shared.downloadTask(with: fileURL) { (tempURL, response, error) in
            guard let tempURL = tempURL, error == nil else {
                print("File download failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 원하는 파일 형식을 여기에서 확인합니다
            let destinationURL: URL?
            if fileURL.pathExtension.lowercased() == "xlsx" {
                destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("your-excel-file.xlsx")
            } else if fileURL.pathExtension.lowercased() == "pdf" {
                destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("your-pdf-file.pdf")
            } else {
                print("Unsupported file type: \(fileURL.pathExtension)")
                return
            }
            
            guard let finalURL = destinationURL else {
                print("Destination URL is nil")
                return
            }
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: finalURL)
                
                print("File downloaded to: \(finalURL)")
                
                // 다운로드 완료 후 원하는 동작 수행
                // 예를 들어, 파일 다운로드 완료 후 다운로드한 파일을 열도록 설정할 수 있습니다.
                // self.openDownloadedFile(at: finalURL)
            } catch {
                print("File move error: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    @objc func showPopup() {
        let alertController = UIAlertController(title: "글 편집", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            let confirmAlertController = UIAlertController(title: "해당 게시글이 삭제됩니다.", message: "해당 게시글은 복구되지 않습니다.", preferredStyle: .alert)
            
            let confirmDeleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
                self.deleteOfficeDetailData()
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            confirmAlertController.addAction(confirmDeleteAction)
            confirmAlertController.addAction(cancelAction)
            
            self.present(confirmAlertController, animated: true, completion: nil)
        }
        
        // "삭제" 버튼의 글자에 색상 설정
        deleteAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteOfficeDetailData() {
        guard let affairId = officeDetailList?.affairId else { return }
        guard let fileName = officeDetailList?.fileInfo.fileName else { return }
        OfficeDetailDeleteService.shared.deleteOfficeDetailFile(affairId: affairId, fileName: fileName) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? OfficeDetailDeleteResponse else { return }
                self.navigationController?.popViewController(animated: true)
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
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }

        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(usedAmountLabel)
        usedAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(50)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(remainingAountLabel)
        remainingAountLabel.snp.makeConstraints { make in
            make.top.equalTo(usedAmountLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(remainingAountLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
    }

}
