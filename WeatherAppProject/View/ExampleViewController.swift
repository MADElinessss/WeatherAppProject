import UIKit

class ExampleViewController: UIViewController {
    
    let footerView = UIView()
    let mapButton = UIButton()
    let listButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰의 기본 배경색 설정
        view.backgroundColor = .white
        
        // footerView 설정
        configureFooterView()
        
        // footerView 레이아웃 설정
        layoutFooterView()
    }
    
    func configureFooterView() {
        // footerView에 버튼 추가
        footerView.addSubview(mapButton)
        footerView.addSubview(listButton)
        
        // footerView의 배경색 설정
        footerView.backgroundColor = .lightGray
        
        // mapButton 설정
        mapButton.setTitle("Map", for: .normal)
        mapButton.backgroundColor = .blue
        
        // listButton 설정
        listButton.setTitle("List", for: .normal)
        listButton.backgroundColor = .red
        
        // footerView를 메인 뷰에 추가
        view.addSubview(footerView)
    }
    
    func layoutFooterView() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.translatesAutoresizingMaskIntoConstraints = false
        
        // footerView의 레이아웃 제약조건 설정
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 100), // 높이 설정
            
            mapButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            mapButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            listButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            listButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }
}

#Preview {
    ExampleViewController()
}
