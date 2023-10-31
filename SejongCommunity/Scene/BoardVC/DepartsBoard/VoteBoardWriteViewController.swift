//
//  VoteBoardWriteViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/30.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
import Alamofire
import PhotosUI

class VoteBoardWriteViewController : UIViewController, UITextViewDelegate {
    var boardType: String = "" // boardType을 저장할 변수
    // 초기화 메서드
    init(boardType: String) {
        super.init(nibName: nil, bundle: nil)
        self.boardType = boardType
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var tableView = UITableView()
    //Textview의 placeholder
    let placeholderText = "내용"
    //마감기한. DatePicker를 전역 변수로 선언
    // DatePicker를 지연 초기화
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "ko_KR")
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    @objc func datePickerValueChanged() {
            updateDateLabel()
    }
    var deadLine = ""
    func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let selectedDate = datePicker.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        deadLine = formattedDate
        print("데드라인 - \(deadLine)")
    }
    //익명 표시
    let anonymousView : UIView = {
        let view = UIView()
        let ccLabel = UIView()
        ccLabel.backgroundColor = #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        ccLabel.layer.cornerRadius = 10
        let StudentLabel = UILabel()
        StudentLabel.text = "익명"
        StudentLabel.textColor = .black
        StudentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .horizontal
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(ccLabel)
        StackView.addArrangedSubview(StudentLabel)
        view.addSubview(StackView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.bottom.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(27)
        }
        ccLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(StackView.snp.width).dividedBy(9.5)
        }
        StudentLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalTo(ccLabel.snp.trailing).offset(20)
        }
        return view
    }()
    // 전역 변수로 선언
    var titleTextField: UITextField? //제목
    var messageTextView: UITextView? //내용
    var addImage: UIImage? //뷰에 추가할 이미지
    var imageInfoArray: [[String: String]] = [] //이미지 이름, 이미지 url
    // 이미지를 5개로 제한
    var AddImageView: [UIImageView] = Array(repeating: UIImageView(), count: 5)
    var imageStack = UIStackView()
    var AddImageScrolling = UIScrollView()
    var imageframe : CGFloat = 0
    var imageNum = 0
    // 로딩 인디케이터
    var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = self.view.center
        //게시판 제목과 글, 그림을 등록하기 위한 뷰
        let OpenWriteView = UIView()
        let WriteStackView = UIStackView()
        WriteStackView.axis = .vertical
        WriteStackView.spacing = 20
        WriteStackView.distribution = .fill
        WriteStackView.alignment = .fill
        WriteStackView.backgroundColor = .white
        var Title = UITextField()
        Title.textAlignment = .left
        Title.placeholder = "제목"
        Title.font = UIFont.boldSystemFont(ofSize: 20)
        Title.layer.cornerRadius = 10
        Title.layer.masksToBounds = true
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // 원하는 크기로 설정
        Title.leftView = spaceView
        Title.leftViewMode = .always // 항상 표시되도록 설정
        //게시물의 본문
        var Message = UITextView()
        Message.textAlignment = .left
        Message.font = UIFont.boldSystemFont(ofSize: 15)
        Message.text = placeholderText
        Message.delegate = self
        Message.textColor = UIColor.lightGray
        Message.layer.cornerRadius = 10
        Message.layer.masksToBounds = true
        
        //게시물의 사진 업로드
        let UploadImage = UIButton()
        UploadImage.backgroundColor = #colorLiteral(red: 1, green: 0.869592011, blue: 0.9207738042, alpha: 1)
        //.action 아이콘 추가
        let iconImage = UIImage(systemName: "square.and.arrow.up")
        UploadImage.setTitle("\tUpload Image\t\t\t\t\t\t", for: .normal)
        UploadImage.setTitleColor(.black, for: .normal)
        UploadImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        UploadImage.contentHorizontalAlignment = .left
        UploadImage.layer.cornerRadius = 10
        UploadImage.layer.masksToBounds = true
        UploadImage.tintColor = .black
        UploadImage.setImage(iconImage, for: .normal)
        UploadImage.semanticContentAttribute = .forceRightToLeft
        UploadImage.addTarget(self, action: #selector(UploadImageTapped), for: .touchUpInside)
        
        let UploadBtn = UIButton()
        UploadBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        UploadBtn.setTitle("업로드", for: .normal)
        UploadBtn.setTitleColor(.black, for: .normal)
        UploadBtn.layer.cornerRadius = 20
        UploadBtn.layer.masksToBounds = true
        UploadBtn.addTarget(self, action: #selector(UploadBtnTapped), for: .touchUpInside)
        
        WriteStackView.addArrangedSubview(Title)
        let Spacing = UIView()
        Spacing.backgroundColor = .gray
        WriteStackView.addArrangedSubview(Spacing)
        WriteStackView.addArrangedSubview(Message)
        AddImageScrolling = UIScrollView()
        AddImageScrolling.backgroundColor = .white
        AddImageScrolling.isScrollEnabled = true
        imageStack = UIStackView()
        imageStack.backgroundColor = .white
        imageStack.distribution = .fill
        imageStack.axis = .horizontal
        imageStack.backgroundColor = .white
        imageStack.spacing = 10
        AddImageScrolling.addSubview(imageStack)
        WriteStackView.addArrangedSubview(AddImageScrolling)
        WriteStackView.addArrangedSubview(UploadImage)
        WriteStackView.addArrangedSubview(UploadBtn)
        OpenWriteView.addSubview(WriteStackView)
        //SnapKit을 이용한 오토레이아웃 설정
        WriteStackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }
        Spacing.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(0.5)
        }
        Message.snp.makeConstraints{(make) in
            make.top.equalTo(Spacing.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(250)
        }
        AddImageScrolling.snp.makeConstraints{ (make) in
            make.top.equalTo(Message.snp.bottom).offset(20)
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        imageStack.snp.makeConstraints{ (make) in
            make.edges.equalTo(AddImageScrolling)
            make.width.equalTo(AddImageScrolling.frame.width)
        }
        UploadImage.snp.makeConstraints{ (make) in
            make.top.equalTo(imageStack.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }
        UploadBtn.snp.makeConstraints{(make) in
            make.top.equalTo(UploadImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        self.titleTextField = Title
        self.messageTextView = Message
        
        let ScrollView = UIScrollView()
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = false
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(anonymousView)
        StackView.addSubview(datePicker)
        StackView.addArrangedSubview(OpenWriteView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-3)
        }
        anonymousView.snp.makeConstraints{ (make) in
//            make.top.equalToSuperview().offset(50)
            make.height.equalTo(StackView.snp.height).dividedBy(10)
            make.leading.equalToSuperview().inset(0)
        }
        datePicker.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().offset(0)
        }
        OpenWriteView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
        }
        setupTapGesture()
    }
    // UITextView Delegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    //화면의 다른 곳을 눌렀을 때 가상키보드가 사라짐
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap() {
        self.view.endEditing(true) // 키보드가 열려있을 경우 닫기
    }
    //업로드 메서드
    @objc func UploadBtnTapped(){
        // 전송할 데이터 (텍스트 뷰와 필드의 내용)
        let titleText = titleTextField?.text ?? ""
        let messageText = messageTextView?.text ?? ""
                
        print("UploadBtnTapped() - \(titleText), \(messageText)")
        if(titleText == ""){
            if(messageText == "내용"){
                //둘다 없을때
                let alertController = UIAlertController(title: nil, message: "제목과 내용을 작성해 주세요.", preferredStyle: .alert)
                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                }
                alertController.addAction(CancelController)
                present(alertController, animated: true)
            }
            //게시글의 제목이 없을때 팝업
            else{
                let alertController = UIAlertController(title: nil, message: "제목을 작성해 주세요.", preferredStyle: .alert)
                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                }
                alertController.addAction(CancelController)
                present(alertController, animated: true)}
        }else if(messageText == "내용"){
            //게시글의 내용이 없을때 팝업
            let alertController = UIAlertController(title: nil, message: "내용을 작성해 주세요.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
            }
            alertController.addAction(CancelController)
            present(alertController, animated: true)
        }else{
            //MARK: image 통신
            // 이미지 배열을 서버로 업로드, 바디에 들어갈 imageInfoArray 업데이트
            print("이미지를 첨부하지 않습니까? - \(AddImageView.count)")
            uploadImagesToServer(images: AddImageView.compactMap { $0.image }){
                print("추가된 이미지 배열입니다. \(self.imageInfoArray)")
                //MARK: JSON 통신
                let urlString = "http://15.164.161.53:8082/api/v1/boards?boardType=\(self.boardType)&isVote=true"
                guard let url = URL(string: urlString) else {
                    // 유효하지 않은 URL 처리
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                //적절할때 통신
                let requestBody: [String: Any] = [
                    "content": messageText, //내용 //자유게시판은 투표글이 아님. 데드라인 없음.
                    "image": self.imageInfoArray, //이미지 이름, 이미지 Url이 있는 배열들
                    "title": titleText, //제목
                    "deadLine" : self.deadLine //데드라인
                ]
                print("바디 값입니다. - \(requestBody)")
                // JSON 데이터를 HTTP 요청 바디에 설정
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []){
                    request.httpBody = jsonData
                }
                // HTTP 요성 헤더 설정(필요에 따라 추가)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let token = KeychainWrapper.standard.string(forKey: "AuthToken")
                request.setValue(token, forHTTPHeaderField: "accessToken")
                var status = 200
                // URLSession을 사용하여 서버와 통신
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버 응답 처리
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else if let data = data {
                        // 서버 응답 데이터 처리 (만약 필요하다면)
                        if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // 서버로부터 받은 JSON 데이터 처리
                            print("Response JSON: \(responseJSON)")
                            status = responseJSON["status"] as? Int ?? 0
                        }
                    }
                    if status == 200 {
                        //적절할때. 업로드 완료가 되었을때. 팝업. reload
                        DispatchQueue.main.async{
                            let alertController = UIAlertController(title: nil, message: "게시글이 업로드 되었습니다.", preferredStyle: .alert)
                            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                                if self.boardType == "Free" {
                                    // OpenBoardViewController로 이동
                                    if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is OpenBoardViewController }) {
                                        self.navigationController?.popToViewController(openboardViewController, animated: true)
                                    }
                                }else if self.boardType == "Council" {
                                    // DepartBoardViewController로 이동
                                    if let departBoardViewController = self.navigationController?.viewControllers.first(where: { $0 is DepartBoardViewController }) {
                                        self.navigationController?.popToViewController(departBoardViewController, animated: true)
                                    }
                                }
                            }
                            alertController.addAction(CancelController)
                            self.present(alertController, animated: true)
                        }
                    }
                }
                task.resume() // 요청 보내기
            }
        }
    }
}
extension VoteBoardWriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 업로드 메서드
    @objc func UploadImageTapped() {
        print("UploadImageTapped - called()")
        if(imageNum >= 5){
            // 최대 5장으로 제한! Alert
            let Alert = UIAlertController(title: "이미지는 최대 5개 업로드할 수 있습니다!", message: nil, preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "확인", style: .default) { (_) in
                //확인 액션
            }
            Alert.addAction(OkAction)
            present(Alert, animated: true)
        }else{
            // 로딩 인디케이터 추가
            self.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    // UIImagePickerControllerDelegate 메서드 - 이미지 선택 취소
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        
        picker.dismiss(animated: true, completion: nil)
    }
    // UIImagePickerControllerDelegate 메서드 - 사진 선택 시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        loadingIndicator.stopAnimating()
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("imagePickerController - \(selectedImage)")
            // 선택한 이미지를 업로드하거나 다른 처리를 수행
            // 선택한 이미지를 어딘가에 저장하는 등 작업 수행
            addImage = selectedImage
            AddImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //AddImageView에 이미지 추가 메서드
    func AddImage() {
        if imageNum == 0 {
            AddImageView = Array(repeating: UIImageView(), count: 5)
        }else if(imageNum > 0 && imageNum == AddImageView.count){
            AddImageView = Array(repeating: UIImageView(), count: 5)
        }
        if imageNum >= 0 && imageNum < AddImageView.count {
            print("이미지를 추가합니다. AddimageView : \(AddImageView.count), imageNum : \(imageNum)")
            AddImageView[imageNum] = UIImageView(image: addImage)
            // 이미지뷰와 삭제 버튼을 포함하는 뷰 생성
            let imageContainerView = UIView()
                    
            // 이미지뷰 생성 및 설정
            let imageView = AddImageView[imageNum]
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            // 삭제 버튼 생성 및 설정
            let deleteButton = UIButton(type: .system)
            deleteButton.backgroundColor = #colorLiteral(red: 0.9230724573, green: 0.9292072654, blue: 0.9290989041, alpha: 1)
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.setTitleColor( #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            
            // 이미지뷰와 삭제 버튼에 인덱스 값을 저장
            imageView.tag = imageNum
            deleteButton.tag = imageNum
            
            // 이미지뷰와 삭제 버튼을 뷰에 추가
            imageContainerView.addSubview(imageView)
            imageContainerView.addSubview(deleteButton)
            
            AddImageView[imageNum].snp.makeConstraints{ (make) in
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            imageView.snp.makeConstraints { (make) in
                make.width.equalTo(100)
                make.height.equalTo(75)
            }
            // 삭제 버튼의 크기와 위치 설정
            deleteButton.snp.makeConstraints { (make) in
                make.width.equalTo(100)
                make.height.equalTo(20)
                make.top.equalTo(imageView.snp.bottom).offset(5)
            }
            imageContainerView.snp.makeConstraints{(make) in
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            print("이미지 프레임 입니다. \(imageframe)")
            // 이미지 스택에 뷰 추가
            imageStack.addArrangedSubview(imageContainerView)
            // 이미지뷰를 추가할 때마다 imageStack의 width 제약을 업데이트합니다.
            //사진은 최대 5장 까지만!!
            imageStack.snp.updateConstraints { (make) in
                make.width.equalTo(100 + imageframe)
            }
            imageNum += 1
            imageframe += 120
            self.addImage = nil
        }else{
            // 이미지 뷰를 추가할 배열 요소가 없을 경우에 대한 처리
            print("이미지를 추가할 배열 요소가 부족합니다. \(imageNum), \(AddImageView.count)")
        }
    }
    // 삭제 메서드
    @objc func deleteImage(_ sender: UIButton) {
        let indexToDelete = sender.tag
        print("\(indexToDelete+1)번째 이미지가 삭제되었습니다.")
        AddImageView = Array(repeating: UIImageView(), count: imageNum)
        if indexToDelete >= 0 && indexToDelete < AddImageView.count {
            // 이미지뷰와 삭제 버튼을 포함하는 뷰를 가져옴
            if let imageContainerView = imageStack.arrangedSubviews[indexToDelete] as? UIView {
                // 이미지뷰와 삭제 버튼을 삭제
                imageContainerView.removeFromSuperview()
                
                // 이미지뷰 배열과 이미지 스택에서 제거
                AddImageView.remove(at: indexToDelete)
                imageStack.removeArrangedSubview(imageContainerView)
                imageNum -= 1
                imageframe -= 120
                print("남은 이미지 개수입니다 - \(imageNum)개")
                // 이미지 스택의 너비 업데이트
                updateImageStackWidth()
                //AddImageView = Array(repeating: UIImageView(), count: 5)
                // 삭제된 이미지 뒤의 이미지들의 인덱스를 업데이트
                print("이미지 갯수 \(AddImageView.count)")
                // 이미지와 버튼의 태그 업데이트
                for i in 0..<AddImageView.count {
                    if let imageContainerView = imageStack.arrangedSubviews[i] as? UIView {
                        if let imageView = imageContainerView.subviews.compactMap({ $0 as? UIImageView }).first,
                            let deleteButton = imageContainerView.subviews.compactMap({ $0 as? UIButton }).first {
                                imageView.tag = i
                                deleteButton.tag = i
                            }
                        }
                    }
                for i in (0..<AddImageView.count){
                    print("현재 인덱스 번호입니다. \(i)\n")
                }
            }else{
                print("삭제할 이미지가 존재하지 않습니다. 인덱스: \(indexToDelete)")
            }
        }
    }
    func updateImageStackWidth() {
        imageStack.snp.updateConstraints{ (make) in
            make.width.equalTo(imageframe)
        }
    }
    func uploadImagesToServer(images: [UIImage],completion: @escaping () -> Void){
        let uploadURLString = "http://15.164.161.53:8082/api/v1/file"
        //액세스 토큰 헤더에 추가
        if let accesToken = KeychainWrapper.standard.string(forKey: "AuthToken") {
            let headers: HTTPHeaders = [
                "Content-Type" : "multipart/form-data",
                "accessToken" : "\(accesToken)"
            ]
            print("서버로 보낼 이미지 갯수 : \(images.count)")
            if(images.count == 0) {
                self.imageInfoArray = []
                completion()
                return
            }
            // Alamofire 사용. 업로드 이미지들을 서버로 전송
            AF.upload(multipartFormData: { multipartFormData in
                for (index, image) in images.enumerated(){
                    if let imageData = image.pngData(){
                        let imageName = "image\(index).jpg"
                        // 내용을 추가하기 전에 로그에 출력
                        print("Adding image with name: \(imageName)")
                        multipartFormData.append(imageData, withName: "files", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                        //서버와의 맞춤 필요
//                        withname – 서버에서 요구하는 key값
//                        fileName – 전송될 파일이름
//                        mimeType – 타입에맞게 image/jpg, image/png, text/plain, 등 타입
                    }
                }
            }, to: uploadURLString, method: .post, headers: headers)
            .response { response in
                // 업로드 완료 후의 응답 처리
                switch response.result {
                case .success(let data):
                    if let data {
                        print("업로드 성공: \(data)")
                    }else{}
                    // 업로드 성공 후의 처리
                    //imageName, imageUrl
                    if let data = data {
                        do {
                            if let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("업로드 결과 입니다. \(responseData)")
                                // JSON 파싱 성공
                                if let resultArray = responseData["result"] as? [[String: Any]] {
                                        for result in resultArray {
                                            if let imageName = result["imageName"] as? String,
                                               let imageUrl = result["imageUrl"] as? String {
                                                // imageName과 imageUrl을 사용
                                                let imageInfo = ["imageName": imageName, "imageUrl": imageUrl]
                                                self.imageInfoArray.append(imageInfo)
                                                print("이미지 배열 입니다. \(self.imageInfoArray)")
                                            } else {
                                                print("imageName 또는 imageUrl을 찾을 수 없습니다.")
                                            }
                                        }
                                        completion()
                                    } else {
                                        print("result 배열을 찾을 수 없습니다.")
                                    }
                            } else {
                                print("JSON 파싱 실패")
                            }
                        } catch {
                            print("JSON 파싱 오류: \(error)")
                        }
                    } else {
                        // data가 nil일 때 처리할 내용을 여기에 작성하세요.
                        print("데이터가 nil입니다.")
                    }
                case .failure(let error):
                    print("업로드 실패: \(error)")
                    // 업로드 실패 시의 처리
                }
            }
        }else{
            //액세스토큰 유효처리. 재발급
            if AuthenticationManager.isTokenValid() {}else {}
        }
    }
}
