//
//  ChatViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    var chatRoomList: [ChatRoomDetailInfoResponseList] = []
    
    let refreshControl = UIRefreshControl()
    private var currentPage: Int = 0
    private var totalPage: Int = 1
    
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
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        chatTableView.refreshControl = refreshControl
        
        setupLayout()
        getChatRoomListInfo(currentPage: currentPage)
    }

    func setupLayout() {
        view.addSubview(chatTableView)
        
        chatTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func getChatRoomListInfo(currentPage: Int) {
        ChatListGetService.shared.getChatRoomListInfo(page: currentPage) { response in
            switch response {
            case .success(let data):
                guard let infoData = data as? ChatRoomListModelResponse else { return }
                if infoData.result.currentPage == 0 {
                    self.chatRoomList = infoData.result.chatRoomDetailInfoResponseList
                } else {
                    let existingSet = Set(self.chatRoomList.map { $0.roomId })
                    let newData = infoData.result.chatRoomDetailInfoResponseList.filter { !existingSet.contains($0.roomId) }
                    self.chatRoomList.append(contentsOf: newData)
                }
                self.totalPage = infoData.result.totalPages
                self.chatTableView.reloadData()
            case .pathErr :
                print("잘못된 파라미터가 있습니다.")
            case .serverErr :
                print("서버에러가 발생했습니다.")
            default:
                print("networkFail")
            }
        }
    }
    
    @objc func refreshTableView() {
        getChatRoomListInfo(currentPage: currentPage)
        chatTableView.refreshControl?.endRefreshing()
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        cell.bindData(chatRoomList: chatRoomList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.roomId = chatRoomList[indexPath.row].roomId
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}

extension ChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        // 스크롤이 맨 아래에 도달했을 때 새로운 페이지의 정보를 받습니다.
        if offsetY > contentHeight - screenHeight && currentPage + 1 < totalPage {
            currentPage += 1
            getChatRoomListInfo(currentPage: currentPage)
        }
    }
}
