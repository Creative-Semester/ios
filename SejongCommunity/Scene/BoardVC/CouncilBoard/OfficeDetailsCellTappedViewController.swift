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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupLayout()
        
    }
    
    func setupNavigation() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showPopup))
            navigationItem.rightBarButtonItem = editButton
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

    }

}
