//
//  ChatRoomViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/21.
//

import UIKit

struct Chatting {
    let text: String
    let isYour: Bool
}

let chatList: [Chatting] = [
    Chatting(text: "안녕하세요!\n오늘날씨가 좋지요~??", isYour: true),
    Chatting(text: "안녕하세요! 반갑습니다.반가워해야핼까남랑너린아머리ㅏㄴㅁ얼댜ㅓㄹ아ㅓ니렁ㅁ냐덜", isYour: false),
    Chatting(text: "오늘 날씨 어때요?\n니가 뭘알아\n죄송해요..", isYour: true),
    Chatting(text: "오늘 날씨는 정말 좋은 걸요~?\n아주 그냥 나이스해요 개꾸리~~\n헐헐!", isYour: false),
    Chatting(text: "너 친구는 몇명있어요??.반가워해야핼까남랑너린아머리ㅏㄴㅁ얼댜ㅓㄹ아ㅓ니렁ㅁ냐덜", isYour: true),
    Chatting(text: "친구는 4명이상있어요 ~~\n니가 뭘알아\n죄송해요..", isYour: false)
]

class ChatRoomViewController: UIViewController {
    
    var boardId: Int?

    private let chattingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let reviewView = UIView()
    
    private let reviewTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .lightGray
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .default
        
        return textView
    }()
    
    private let reviewRegisterButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        print(boardId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "익명 1"
        navigationItem.largeTitleDisplayMode = .never
        
        chattingTableView.dataSource = self
        chattingTableView.delegate = self
        chattingTableView.register(MyChattingTableViewCell.self, forCellReuseIdentifier: "MyChattingTableViewCell")
        chattingTableView.register(YourChattingTableViewCell.self, forCellReuseIdentifier: "YourChattingTableViewCell")
        
        reviewTextView.delegate = self
        
        // 키보드가 생성될때, 숨겨질때를 알기 위해서 NotificationCenter를 통해 확인합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupLayout()
        setupNavigation()
        setupKeyboardDismissRecognizer()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        //메모리 누수 방지를 위해 키보드 관찰을 해제합니다.
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigation() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showPopup))
            navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func showPopup() {
        let alertController = UIAlertController(title: "채팅방 신고", message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고", style: .destructive) { (action) in
            let confirmAlertController = UIAlertController(title: "해당유저를 신고합니다.", message: "신고 후 해당 내용 검토 후 조치됩니다.", preferredStyle: .alert)
            
            let confirmReportActionAction = UIAlertAction(title: "신고", style: .destructive) { (_) in
                let alertController = UIAlertController(
                    title: "신고 완료",
                    message: "신고가 성공적으로 완료되었습니다.",
                    preferredStyle: .alert
                )
                
                let okAction = UIAlertAction(
                    title: "확인",
                    style: .default,
                    handler: nil
                )
                
                alertController.addAction(okAction)
                
                // 현재 화면의 ViewController에서 UIAlertController를 표시
                self.present(alertController, animated: true, completion: nil)
                // 채팅방 신고 로직 구현
                // 여기에 신고 통신 코드 추가하기.
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            confirmAlertController.addAction(confirmReportActionAction)
            confirmAlertController.addAction(cancelAction)
            
            self.present(confirmAlertController, animated: true, completion: nil)
        }
        
        // "삭제" 버튼의 글자에 색상 설정
        reportAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //화면의 다른 곳을 클릭했을 때 키보드가 내려가게 합니다.
    private func setupKeyboardDismissRecognizer() {
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
       view.endEditing(true)
    }
    
    func heightCellForText(_ text: String) -> CGFloat {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14) // 원하는 폰트 크기 설정
        label.numberOfLines = 0 // 여러 줄 허용
        label.text = text
        
        // Label의 가로 제한 설정
        let maxLabelWidth: CGFloat = 300
        label.preferredMaxLayoutWidth = maxLabelWidth
        
        // Label의 크기 계산
        let labelSize = label.sizeThatFits(CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude))
        
        // 최소 높이 설정
        let minHeight: CGFloat = 14
        
        // 최소 높이보다 작으면 최소 높이를 반환, 그렇지 않으면 계산된 높이 반환
        let height = max(labelSize.height, minHeight)
        
        return height
    }
    
    func heightForReviewText(_ text: String) -> CGFloat {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = text
        
        // 텍스트를 표시하고 있는 라벨의 크기를 계산합니다.
        let size = label.sizeThatFits(CGSize(width: reviewTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        
        // 최소 높이를 50으로 설정
        let minHeight: CGFloat = 50.0
        
        // 최대 4줄까지 높이가 커지도록 설정
        let maxHeight = label.font.lineHeight * 4 + 10 // 여백 등을 고려하여 최대 높이 계산
        
        // 최소 높이와 실제 높이, 최대 높이 중 적절한 값을 반환
        return max(min(size.height + 34, maxHeight), minHeight)
    }
    
    // 높이를 계산하고 그 결과에 따라 reviewTextView의 높이 제약을 업데이트합니다.
    func updateReviewTextViewHeight() {
        // 원본 텍스트를 가져와서 높이를 계산합니다.
        let originalText = reviewTextView.text ?? ""
        let newHeight = heightForReviewText(originalText)
        
        // 높이 제약을 업데이트합니다.
        reviewView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
        
        // 화면 갱신을 요청하여 제약 조정을 반영합니다.
        view.layoutIfNeeded()
    }
    
    func setupLayout() {
        
        view.addSubview(reviewView)
        reviewView.snp.makeConstraints{ make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        reviewView.addSubview(reviewRegisterButton)
        reviewRegisterButton.snp.makeConstraints{ make in
            make.trailing.equalTo(reviewView.snp.trailing).inset(12)
            make.bottom.equalTo(reviewView.snp.bottom).inset(5)
            make.height.width.equalTo(40)
        }
        
        reviewView.addSubview(reviewTextView)
        reviewTextView.snp.makeConstraints{ make in
            make.top.equalTo(reviewView.snp.top).offset(5)
            make.leading.equalTo(reviewView.snp.leading).inset(12)
            make.trailing.equalTo(reviewRegisterButton.snp.leading).offset(-6)
            make.bottom.equalTo(reviewView.snp.bottom).offset(-5)
        }
        
        view.addSubview(chattingTableView)
        chattingTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(reviewView.snp.top)
        }
    }
}


extension ChatRoomViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateReviewTextViewHeight()
    }
    
    //엔터키를 눌렀을 경우 서버에 /n값을 추가하기 위해서 해당 함수를 추가했습니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == reviewTextView {
            // 엔터키를 눌렀을 때 줄바꿈 처리
            if string == "\n" {
                textField.text?.append("\n")
                return false
            }
        }
        print(textField)
        return true
    }
    
    //키보드가 보였을 때
    @objc func keyboardWillShow(_ notification: Notification) {
        //키보드 프레임 높이
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height // 키보드 높이
        let safeAreaBottom = view.safeAreaLayoutGuide.layoutFrame.maxY //safeArea의 bottom 위치
        let viewBottom = view.bounds.maxY //휴대폰 하단의 위치

        let difference = viewBottom - safeAreaBottom //safeAreaLayoutGuide의 bottom과 휴대폰 최하단의 bottom의 길이 차이
        
        // reviewView 위치 조정 키보드 바로 위에 댓글입력칸이 바로 붙기 위해서 safe공백을 추가했습니다.
        reviewView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight + difference)
        }
        
        // 애니메이션 적용하여 부드럽게 업데이트
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // reviewView 원래 위치로 돌려주기
        reviewView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 애니메이션 적용하여 부드럽게 업데이트
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
}


extension ChatRoomViewController: UITableViewDataSource {
    
    // 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //각 섹션 마다 cell row 숫자의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatList[indexPath.row].isYour {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChattingTableViewCell", for: indexPath) as! MyChattingTableViewCell
            
            cell.configure(with: chatList[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChattingTableViewCell", for: indexPath) as! YourChattingTableViewCell
            
            cell.configure(with: chatList[indexPath.row])
            
            return cell
        }
    }
    
}

extension ChatRoomViewController: UITableViewDelegate {
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let textHeight = heightCellForText(chatList[indexPath.row].text)
        let additionalSpacing = CGFloat(20) //강의평으로 작성된 것이 아닌, 닉네임, 날짜 등의 공백의 길이입니다.

        //다른 공백과 댓글이 작성된 높이의 합이 cell의 높이로 지정합니다.
        return textHeight + additionalSpacing
    }
}
