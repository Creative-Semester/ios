//
//  PostDetailViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
//게시물의 상세 내용을 보여주는 UIViewController
class PostDetailViewController : UIViewController {
    let post : Post
    //이니셜라이저를 사용하여 Post 객체를 전달받아 post 속성에 저장
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .red
        title = post.title
        setupViews()
    }
    //게시물의 상세 내용을 보여줄 라벨을 설정하는 메서드
    func setupViews() {
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200))
        label.text = post.content
        //numberOfLines 속성을 0으로 설정하여 여러 줄의 텍스트를 표시할 수 있도록 함
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
    }
}

