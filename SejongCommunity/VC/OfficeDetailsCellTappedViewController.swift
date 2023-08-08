//
//  OfficeDetailsCellTappedViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/08.
//

import UIKit

class OfficeDetailsCellTappedViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "해지기전 행사 사무내역"
        label.numberOfLines = 0
        
        return label
    }()
    
    private var checkBoxImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        
    }
    

    func setup() {
        view.addSubview(titleLabel)
        view.addSubview(checkBoxImage)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

    }

}
