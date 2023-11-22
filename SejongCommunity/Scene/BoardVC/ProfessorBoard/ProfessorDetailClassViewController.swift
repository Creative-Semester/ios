//
//  ProfessorDetailClassViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/13.
//

import UIKit
import SnapKit

class ProfessorDetailClassViewController: UIViewController {
    
    var professorId: Int?
    var courseId: Int?
    var evaluationList: [EvaluationList] = []
    private var currentPage: Int = 0
    private var totalPage: Int = 1

    private let professorReviewTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
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
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        professorReviewTableView.dataSource = self
        professorReviewTableView.delegate = self
        professorReviewTableView.register(ProfessorReviewTableViewCell.self, forCellReuseIdentifier: "ProfessorReviewTableViewCell")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        professorReviewTableView.refreshControl = refreshControl
        reviewRegisterButton.addTarget(self, action: #selector(reviewRegisterButtonTapped), for: .touchUpInside)
        
        reviewTextView.delegate = self
        
        // 키보드가 생성될때, 숨겨질때를 알기 위해서 NotificationCenter를 통해 확인합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupKeyboardDismissRecognizer()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfessorEvaluationData(currentPage: currentPage)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        //메모리 누수 방지를 위해 키보드 관찰을 해제합니다.
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //화면의 다른 곳을 클릭했을 때 키보드가 내려가게 합니다.
    private func setupKeyboardDismissRecognizer() {
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    }
    
    @objc func reviewRegisterButtonTapped() {
        if reviewTextView.text == "" {
            let alertController = UIAlertController(title: "알림", message: "작성한 내용이 없습니다.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            postProfessorEvaluationData(text: reviewTextView.text)
        }
    }
    
    @objc func refreshTableView() {
        getProfessorEvaluationData(currentPage: currentPage)
        professorReviewTableView.refreshControl?.endRefreshing()
    }
    
    @objc private func dismissKeyboard() {
       view.endEditing(true)
    }
    
    func getProfessorEvaluationData(currentPage: Int) {
        
        guard let professorId = professorId else { return }
        guard let courseId = courseId else { return }
        
        ProfessorEvaluationService.shared.getProfessorEvaluationInfo(professorId: professorId, courseId: courseId, page: currentPage) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorEvaluationResponse else { return }
                if infoData.result.currentPage == 0 {
                    self.evaluationList = infoData.result.evaluationList
                } else {
                    let existingSet = Set(self.evaluationList.map { $0.evaluationId })
                    let newData = infoData.result.evaluationList.filter { !existingSet.contains($0.evaluationId) }
                    self.evaluationList.append(contentsOf: newData)
                }
                self.totalPage = infoData.result.totalPage
                self.professorReviewTableView.reloadData()
                
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
    
    func postProfessorEvaluationData(text: String) {
        
        guard let professorId = professorId else { return }
        guard let courseId = courseId else { return }
        
        ProfessorEvaluationPostService.shared.postProfessorEvaluationInfo(professorId: professorId, courseId: courseId, text: text) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorPostReviewResponse else { return }
                let alertController = UIAlertController(title: "알림", message: "작성이 완료되었습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.reviewTextView.text = ""
                self.getProfessorEvaluationData(currentPage: self.currentPage)
                
                // 실패할 경우에 분기처리는 아래와 같이 합니다.
            
            default:
                let alertController = UIAlertController(title: "알림", message: "작성에 실패했습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
        
        view.addSubview(professorReviewTableView)
        professorReviewTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(reviewView.snp.top)
        }
        
    }
    
    //tableViewCell의 높이를 결정하기 위해 작성된 댓글의 길이의 높이를 측정합니다.
    func heightForText(_ text: String) -> CGFloat {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12) // 원하는 폰트 크기 설정
        label.numberOfLines = 0 // 여러 줄 허용
        label.text = text
        
        // 텍스트를 표시하고 있는 라벨의 크기를 계산
        // -24는 inset(12)의 여백을 제거한 것입니다.
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 24, height: CGFloat.greatestFiniteMagnitude))
        
        return size.height
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
}

extension ProfessorDetailClassViewController: UITextViewDelegate {
    
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

extension ProfessorDetailClassViewController: UITableViewDataSource {
    
    // 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //각 섹션 마다 cell row 숫자의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return evaluationList.count
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorReviewTableViewCell", for: indexPath) as! ProfessorReviewTableViewCell
        cell.delegate = self
        
        cell.configure(evaluationList: evaluationList[indexPath.row])
        
        return cell
    }
    
}

extension ProfessorDetailClassViewController: UITableViewDelegate {
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentText = evaluationList[indexPath.row].text
        
        let textHeight = heightForText(commentText)
        let additionalSpacing = CGFloat(76) //강의평으로 작성된 것이 아닌, 닉네임, 날짜 등의 공백의 길이입니다.
        
        //다른 공백과 댓글이 작성된 높이의 합이 cell의 높이로 지정합니다.
        return textHeight + additionalSpacing
    }
}


extension ProfessorDetailClassViewController: ProfessorReviewTableViewCellDelegate {
    
    func deleteProfessorEvaluationData(evaluationId: Int) {
        
        guard let professorId = professorId else { return }
        guard let courseId = courseId else { return }
        
        ProfessorEvaluationDeleteService.shared.deleteProfessorEvaluationInfo(professorId: professorId, courseId: courseId, evaluationId: evaluationId) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorPostReviewResponse else { return }
                let alertController = UIAlertController(title: "알림", message: "삭제가 완료되었습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                if let index = self.evaluationList.firstIndex(where: { $0.evaluationId == evaluationId }) {
                    self.evaluationList.remove(at: index)
                    self.professorReviewTableView.reloadData()
                }
            
            default:
                let alertController = UIAlertController(title: "알림", message: "삭제가 실패했습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func reportProfessorEvaluation(evaluationId: Int) {
        
        guard let professorId = professorId else { return }
        guard let courseId = courseId else { return }
        
        ProfessorEvaluationReportService.shared.reportProfessorEvaluation(professorId: professorId, courseId: courseId, evaluationId: evaluationId) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorPostReviewResponse else { return }
                let alertController = UIAlertController(title: "알림", message: "신고가 완료되었습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            
            default:
                let alertController = UIAlertController(title: "알림", message: "신고에 실패했습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func buttonTappedWithEvaluationId(_ evaluationId: Int, task: String) {
        if task == "remove" {
            let alertController = UIAlertController(title: "삭제하시겠습니까?", message: "삭제한 데이터는 복구할 수 없습니다.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                // 삭제 버튼이 눌렸을 때의 동작
                self.deleteProfessorEvaluationData(evaluationId: evaluationId)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else if task == "report" {
            let alertController = UIAlertController(title: "신고하시겠습니까?", message: "해당 유저는 검토 후 이용이 제한됩니다.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "신고", style: .destructive) { _ in
                // 신고 버튼이 눌렸을 때의 동작
                self.reportProfessorEvaluation(evaluationId: evaluationId)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension ProfessorDetailClassViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        // 스크롤이 맨 아래에 도달했을 때 새로운 페이지의 정보를 받습니다.
        if offsetY > contentHeight - screenHeight && currentPage + 1 < totalPage {
            currentPage += 1
            getProfessorEvaluationData(currentPage: currentPage)
        }
    }
}
