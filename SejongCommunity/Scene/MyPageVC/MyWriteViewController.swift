//
//  MyWriteViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/19.
//

import Foundation
import UIKit
import SnapKit

class MyWriteViewController : UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        title = "내가 쓴 글"
    }
}
