//
//  ChatViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    private let chatTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "메시지"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic // 또는 .always, .never
        navigationItem.title = "메시지"
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        
        setupLayout()
        
    }

    func setupLayout() {
        view.addSubview(chatTableView)
        
        chatTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)셀이 선택되었습니다.")
        let vc = ChatRoomViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
