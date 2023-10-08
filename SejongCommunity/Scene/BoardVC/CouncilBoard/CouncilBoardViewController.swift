//
//  CouncilBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/25.
//

import UIKit
import SnapKit
import DGCharts

class CouncilBoardViewController : UIViewController {
    
    private let studentCouncilImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "studentCouncil")
        
        return imageView
    }()
    
    private let studentCouncilNameLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "AI로봇공학과"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let studentCouncilNumLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "제 7대 학생회"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let studentCouncilExpLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "RU:RI - 하나되어 울리는 두드림입니다."
        label.numberOfLines = 1
        
        return label
    }()
    
    
    private let officeDetailButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("사무내역보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)

        return button
    }()
    
    private let officeDetailRightErrow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    private let lineView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let pledgeTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "공약 이행도"
        label.numberOfLines = 1
        
        return label
    }()
    
    
    private let pledgeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("전체보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)
        
        return button
    }()
    
    private let pledgeRightErrow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    
    private var barChartView: HorizontalBarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "학생회"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .red
        self.view.backgroundColor = .white
        
        barChartView = HorizontalBarChartView()
        
        pledgeButton.addTarget(self, action: #selector(pledgeButtonTabbed), for: .touchUpInside)
        officeDetailButton.addTarget(self, action: #selector(officeDetailButtonTapped), for: .touchUpInside)

        getCouncilInfoData()
        getPromisesPercentageData()
        setupStudentCouncilView()
    }
    
    func setupBarChart(promisesPercentage: PromisesPercentage) {
        // 그래프 데이터 생성
        let deptPromiseRate = promisesPercentage.deptPromiseRate

        var entries: [BarChartDataEntry] = []
        

        for (index, rate) in deptPromiseRate.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: rate.percent)
            entries.append(entry)
        }
        entries.append(BarChartDataEntry(x: Double(deptPromiseRate.count), y: promisesPercentage.totalPercent))
        
        // 데이터셋 생성
        let dataSet = BarChartDataSet(entries: entries, label: "공약 이행률")
        dataSet.valueFont = UIFont.systemFont(ofSize: 12) // 글꼴 크기
        dataSet.valueTextColor = .black // 글꼴 색상
        
        // 그래프 색상 설정
        dataSet.colors = ChartColorTemplates.colorful()
        
        // 레이블 포맷터 설정 (제목 추가)
        let formatter = DefaultValueFormatter(formatter:NumberFormatter())
        dataSet.valueFormatter = formatter
        
        // 그래프 데이터 생성
        let data = BarChartData(dataSet: dataSet)
        
        barChartView.isUserInteractionEnabled = false //터치 불가
        barChartView.rightAxis.enabled = false //하단의 기본 0.2, 0.4, 0.6 등 표시 제한
        
        // X축 레이블 설정
        var titles = deptPromiseRate.map { $0.departmentName }
        titles.append("전체공약률")
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: titles)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        
        
        // Y축 레이블 설정
        let yAxisFormatter = NumberFormatter()
        yAxisFormatter.numberStyle = .percent
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: yAxisFormatter)
        barChartView.leftAxis.labelPosition = .outsideChart
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 1.0 // 백분율이므로 최대값은 1.0입니다.
        
        // 그래프에 데이터 설정
        barChartView.data = data
        
        // 애니메이션 설정 (선택사항)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
        
        
        // 바탕색 변경
        barChartView.backgroundColor = .white
    }
    
    func getCouncilInfoData() {
        
        CouncilInfoService.shared.getCheckUserInfo() { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? CouncilInfoResponse else { return }
                self.studentCouncilNameLabel.text = infoData.result.name
                self.studentCouncilNumLabel.text = "제 \(String(infoData.result.number))대 학생회"
                self.studentCouncilExpLabel.text = infoData.result.introduce
                
                
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
    
    func getPromisesPercentageData() {
        
        PromisesPercentageService.shared.getPromisesPercentage() { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? PromisesPercentageResponse else { return }
                self.setupBarChart(promisesPercentage: infoData.result)
                
                
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


extension CouncilBoardViewController {
    
    @objc private func officeDetailButtonTapped() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = OfficeDetailsViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func pledgeButtonTabbed() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = PledgeBoardViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func setupStudentCouncilView() {
        
        view.addSubview(studentCouncilImageView)
        studentCouncilImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        
        view.addSubview(studentCouncilNameLabel)
        studentCouncilNameLabel.snp.makeConstraints { make in
            make.top.equalTo(studentCouncilImageView.snp.bottom).offset(15)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(studentCouncilNumLabel)
        studentCouncilNumLabel.snp.makeConstraints { make in
            make.top.equalTo(studentCouncilNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(studentCouncilExpLabel)
        studentCouncilExpLabel.snp.makeConstraints { make in
            make.top.equalTo(studentCouncilNumLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(officeDetailButton)
        officeDetailButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.bottom.equalTo(studentCouncilExpLabel.snp.bottom).offset(6.5)
        }
        
        view.addSubview(officeDetailRightErrow)
        officeDetailRightErrow.snp.makeConstraints { make in
            make.leading.equalTo(officeDetailButton.snp.trailing)
            make.centerY.equalTo(officeDetailButton.snp.centerY)
            make.height.width.equalTo(13)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(officeDetailButton.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.height.equalTo(1)
        }
        
        view.addSubview(pledgeTitleLabel)
        pledgeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.height.equalTo(20)
        }
        
        view.addSubview(pledgeButton)
        pledgeButton.snp.makeConstraints { make in
            make.bottom.equalTo(pledgeTitleLabel.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        
        view.addSubview(pledgeRightErrow)
        pledgeRightErrow.snp.makeConstraints { make in
            make.leading.equalTo(pledgeButton.snp.trailing)
            make.centerY.equalTo(pledgeButton.snp.centerY)
            make.height.width.equalTo(13)
        }
        
        view.addSubview(barChartView)
        barChartView.snp.makeConstraints { make in
            make.top.equalTo(pledgeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
}
