//
//  ProfessorBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/31.
//

import UIKit
import SnapKit

class ProfessorBoardViewController: UIViewController {
    
    private var professorInfoList: [ProfessorInfo] = []
    private var currentPage: Int = 0
    private var totalPage: Int = 1

    private let professorCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "교수 게시판"
        self.navigationController?.navigationBar.tintColor = .red
        professorCollecionView.register(ProfessorCollectionViewCell.self, forCellWithReuseIdentifier: "ProfessorCollectionViewCell")
        professorCollecionView.delegate = self
        professorCollecionView.dataSource = self
        
        getProfessorInfoData(currentPage: currentPage)
        setupLayout()
    }
    

    func setupLayout() {
        view.addSubview(professorCollecionView)
        professorCollecionView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func getProfessorInfoData(currentPage: Int) {
        
        ProfessorInfoService.shared.getProfessorInfo(page: currentPage) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorInfoResponse else { return }
                if infoData.result.currentPage == 0 {
                    self.professorInfoList = infoData.result.list
                } else {
                    let existingSet = Set(self.professorInfoList.map { $0.professorId })
                    let newData = infoData.result.list.filter { !existingSet.contains($0.professorId) }
                    self.professorInfoList.append(contentsOf: newData)
                }
                self.totalPage = infoData.result.totalPage
                self.professorCollecionView.reloadData()
                
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
}

extension ProfessorBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return professorInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = professorCollecionView.dequeueReusableCell(withReuseIdentifier: "ProfessorCollectionViewCell", for: indexPath) as! ProfessorCollectionViewCell
        
        cell.configure(professorInfo: professorInfoList[indexPath.row])
        
        return cell
    }
}

extension ProfessorBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfessorInfoViewController()
        vc.professorId = professorInfoList[indexPath.row].professorId
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfessorBoardViewController: UICollectionViewDelegateFlowLayout {
    // collectionView 셀 크기 반환
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: UIScreen.main.bounds.width - 30, height: 150)
    }
    
    // collectionView 셀과 셀 사이 간격 반환
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension ProfessorBoardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        // 스크롤이 맨 아래에 도달했을 때 새로운 페이지의 정보를 받습니다.
        if offsetY > contentHeight - screenHeight && currentPage + 1 < totalPage {
            currentPage += 1
            getProfessorInfoData(currentPage: currentPage)
        }
    }
}
