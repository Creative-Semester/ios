//
//  OfficeDetailsCellTappedViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/08.
//

import UIKit
import SnapKit

class OfficeDetailsCellTappedViewController: UIViewController {

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
        
        button.setTitle("사용내역 파일 다운로드", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        downloadButton.addTarget(self, action: #selector(downloadExcelFile), for: .touchUpInside)
        
        setupNavigation()
        setupLayout()
        
    }
    
    func setupNavigation() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showPopup))
            navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func downloadExcelFile() {
        // 파일 다운로드 URL 또는 경로 설정
        guard let fileURL = URL(string: "https://example.com/your-excel-file.xlsx") else {
            print("Invalid file URL")
            return
        }
        
        // 파일 다운로드 작업 시작
        URLSession.shared.downloadTask(with: fileURL) { (tempURL, response, error) in
            guard let tempURL = tempURL, error == nil else {
                print("File download failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // 다운로드한 파일을 원하는 위치에 저장
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = documentsDirectory.appendingPathComponent("your-excel-file.xlsx")
                
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                
                // 다운로드 완료 후 원하는 동작 수행
                print("File downloaded to: \(destinationURL)")
                
                // 예를 들어, 파일 다운로드 완료 후 다운로드한 파일을 열도록 설정할 수 있습니다.
                // self.openDownloadedExcelFile(at: destinationURL)
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
                // 게시글 삭제 로직을 여기에 구현
                self.navigationController?.popViewController(animated: true)
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
