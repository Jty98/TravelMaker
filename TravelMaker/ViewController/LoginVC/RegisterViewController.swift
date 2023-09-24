//
//  RegisterViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import DropDown // dropdown cocoapod 추가하고 import해주기
import FirebaseAuth // Firebase 로그인, 회원가입 기능을 쓰기위함
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // DropDown부분 Outlet
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var btnDropAction: UIButton!
    
    // TextFiield부분 Outlet
    @IBOutlet weak var tfId: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordVerify: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    // regex메세지
    @IBOutlet weak var lblIdMessage: UILabel!
    @IBOutlet weak var lblEmailMessage: UILabel!
    @IBOutlet weak var lblVerifyMessage: UILabel!
    @IBOutlet weak var lblNameMessage: UILabel!
    @IBOutlet weak var lblPasswordMessage: UILabel!
    
    // 성별 체크박스 버튼
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    // DropDown에서 선택된 이메일 주소를 저장하는 변수
    var selectedDropDwonEmail = ""
    // 선택된 전체 email을 저장하는 변수
    var emailAddres = ""
    // DropDown 객체 생성
    let dropdown = DropDown()
    // DropDown 이메일 리스트
    let emailList = ["직접입력", "naver.com", "gmail.com", "daum.net", "nate.com"]
    
    // 성별 선택 체크박스 Status
    var maleSelected = true
    var femaleSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DropDown생성 및 세팅
        initUI()
        setDropDown()
        
        // Label 초기화
        lblIdMessage.text = ""
        lblEmailMessage.text = ""
        lblPasswordMessage.text = ""
        lblVerifyMessage.text = ""
        lblNameMessage.text = ""
        
        // UITextFieldDelegate를 설정하여 텍스트 필드 입력을 모니터링
        tfId.delegate = self
        tfEmailAddress.delegate = self
        
        // 텍스트 필드의 변경 이벤트를 모니터링하도록 타겟을 추가(실시간으로 바뀌게끔 해줌)
        tfId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfEmailAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfPasswordVerify.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // password가리기
        tfPasswordVerify.textContentType = .oneTimeCode // 이렇게 해야지 keyboard로 했을 때 오류 안남
        tfPasswordVerify.isSecureTextEntry = true
        
        // 키보드 내리기
        setKeyboardEvent()
    } // ViewDidLoad
    
    // keyboard 빈화면 클릭시 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드가 생성될 때 메모리에 상주하는 옵저버와 없어질때 옵저버 두개 필요함
    func setKeyboardEvent(){
        // 키보드가 생겼을 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 없어졌을 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisApper(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 키보드가 생겼을 때
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y = -200 // 250만큼 화면을 올려줌(누적시키면 안됨)
    }
    // 키보드가 없어졌을 때
    @objc func keyboardWillDisApper(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0 // 0으로 다시 보내서 다시 원상복구
    }
    
    // DropDown초기설정
    func initUI(){
        // DropDown View 배경
        dropView.backgroundColor = UIColor.white
        dropdown.layer.cornerRadius = 0
        
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.blue // 선택된 아이템 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업 닫을 모드 설정
        
        tfEmailAddress.placeholder = "직접입력" // 힌트 텍스트
        
        btnDropAction.tintColor = UIColor.gray // 버튼 색상
    } // ===== initUI =====
    
    
    // DropDown item이 선택될 때 이벤트
    func setDropDown(){
        // dataSource로 ItemList를 연결하기
        dropdown.dataSource = emailList
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.dropView
        // View 를 가리지 않고 View 아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: dropView.bounds.height)
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            self!.tfEmailAddress.text = item    // textfield에 선택된 item 출력
            self!.selectedDropDwonEmail = item  // 전역변수에 선택된 item저장
            //            self!.domainCheck() // regex실행
            self!.btnDropAction.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
            // 직접입력이 선택돼 있을 때 textfield비우기
            if item == "직접입력"{
                self!.tfEmailAddress.text = ""
            }
        }
        // 취소 시 처리
        dropdown.cancelAction = { [weak self] in
            // 빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.btnDropAction.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        }
    } // ===== setDropDown =====
    
    
    // DropDown 오른쪽 버튼 눌렸을 때
    @IBAction func dropDownClicked(_ sender: UIButton) {
        if dropdown.isHidden {
            // 드롭다운 숨겨진 경우: 드롭다운을 보여주고 아이콘을 위로 화살표로 변경
            dropdown.show() // 드롭다운 펼치기
            self.btnDropAction.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
        } else {
            // 드롭다운이 보여지고 있는 경우: 드롭다운을 숨기고 아이콘을 아래로 화살표로 변경
            dropdown.hide() // 드롭다운을 숨김
            self.btnDropAction.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        }
    } // ===== dropDownClicked =====
    
    
    // Regex해주는 부분
    // 텍스트 필드의 변경 이벤트를 실시간으로 처리하게 해주는 함수
    @objc func textFieldDidChange(_ textField: UITextField) {
        let id = tfId.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let domain = tfEmailAddress.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = tfPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let passwordVerify = tfPasswordVerify.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let name = tfName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        // 입력된 텍스트를 합처서 전체 이메일 주소를 저장
        emailAddres = "\(id)@\(domain)"
        
        // regex클래스 인스턴스 생성
        let regexCheck = regex()
        
        // 받아온 textfield 부분의 유효성을 검사
        let isIdValid = regexCheck.isValidId(id: id)
        let isDomainValid = regexCheck.isValidDomain(domain: domain)
        let isPasswordValid = regexCheck.isValidPassword(password: password)
        let isNameValid = regexCheck.isValidName(name: name)
        
        // 결과에 따라 라벨에 메시지 표시
        // id부분
        if id == "" {
            lblIdMessage.text = ""
        }else{
            if isIdValid{
                lblIdMessage.text = "사용 가능한 ID"
                lblIdMessage.textColor = UIColor.blue
            }else{
                lblIdMessage.text = "5~20자의 영문 소문자, 숫자, _, - 만 사용 가능"
                lblIdMessage.textColor = UIColor.red
            }
        }
        // 도메인 부분
        // 드롭다운 선택이 안됐을때도 라벨에 text가 출력되는 것을 막기위해 아무것도 입력 안됐을 때는 공백
        if domain == "" {
            lblEmailMessage.text = ""
        }else{
            if isDomainValid{
                lblEmailMessage.text = "유효한 도메인"
                lblEmailMessage.textColor = UIColor.blue
            }else{
                lblEmailMessage.text = "유효하지 않은 도메인"
                lblEmailMessage.textColor = UIColor.red
            }
        }
        // password부분
        if password == ""{
            lblPasswordMessage.text = ""
        }else{
            if isPasswordValid{
                lblPasswordMessage.text = "유효한 비밀번호"
                lblPasswordMessage.textColor = UIColor.blue
            }else{
                lblPasswordMessage.text = "8자 이상의 영문 소문자, 1개이상의 대문자와 1개이상의 특수문자를 포함"
                lblPasswordMessage.textColor = UIColor.red
            }
        }
        // passwordVerify부분
        if passwordVerify == "" || lblPasswordMessage.text == "8자 이상의 영문 소문자, 1개이상의 대문자와 1개이상의 특수문자를 포함"{
            lblVerifyMessage.text = ""
        }else{
            if password == passwordVerify{
                lblVerifyMessage.text = "비밀번호가 일치합니다."
                lblVerifyMessage.textColor = UIColor.blue
            }else{
                lblVerifyMessage.text = "비밀번호가 일치하지 않습니다."
                lblVerifyMessage.textColor = UIColor.red
            }
        }
        // name부분
        if name == ""{
            lblNameMessage.text = ""
        }else{
            if isNameValid{
                lblNameMessage.text = "사용 가능한 이름입니다."
                lblNameMessage.textColor = UIColor.blue
            }else{
                lblNameMessage.text = "특수문자를 제외한 2~8자리"
                lblNameMessage.textColor = UIColor.red
            }
        }
    } // ===== textFieldDidChange =====
    
    
    // == 성별체크부분 ==
    // 남자 체크
    @IBAction func btnMale(_ sender: UIButton) {
        maleSelected = true
        femaleSelected = false
        
        maleButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "square"), for: .normal)    }
    
    // 여자 체크
    @IBAction func btnFemale(_ sender: UIButton) {
        maleSelected = false
        femaleSelected = true
        
        maleButton.setImage(UIImage(systemName: "square"), for: .normal)
        femaleButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    } // == 성별체크부분 ==
    


} // RegisterViewController
