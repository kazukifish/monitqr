//
//  ProjectAViewController.swift
//  MONITQR3
//
//  Created by 出田和毅 on 2023/10/24.
//

import UIKit
import Foundation

class ProjectAViewController: UIViewController, UITextFieldDelegate {
    
    // UIButton
    let cameraButton = UIButton()
    let fileButton = UIButton()
    let graphButton = UIButton()
    
    // UILabel
    let textLabel = UILabel()
    
    // MyView
    var myView: UIView!
    var myView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewの背景色
        view.backgroundColor = .systemTeal
        
        // UILabel
        textLabel.text = "This is the first project for monitoring."
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.boldSystemFont(ofSize: 15)
        // textLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        self.view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        // myView
        myView = UIView(frame: CGRectMake(0, 0, 120, 120))
        myView.backgroundColor = UIColor.green
        myView.alpha = 0.3 // 透明度を設定
        myView.layer.position = CGPointMake(self.view.frame.width/3, self.view.frame.height*3/5)
        self.view.addSubview(myView)
        // myView2
        myView = UIView(frame: CGRectMake(0, 0, 180, 180))
        myView.backgroundColor = UIColor.systemMint
        myView.alpha = 0.7 // 透明度を設定
        myView.layer.position = CGPointMake(self.view.frame.width*2/3, self.view.frame.height*9/20)
        self.view.addSubview(myView)
        
        
        // Create UIButton for Camera
        cameraButton.setTitle("Camera", for: .normal) // ボタンタイトル
        cameraButton.setTitleColor(.white, for: .normal) // 文字の色
        cameraButton.backgroundColor = UIColor.clear // ボタンの色
        cameraButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14) // ボタンタイトルのフォント：太字
        cameraButton.layer.cornerRadius = 18.0 // ボタンの角を丸くする
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 4
        cameraButton.layer.opacity = 0.7
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        // button layout
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        // cameraButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        // cameraButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        // Create UIButton for File
        fileButton.setTitle("File", for: .normal)
        fileButton.setTitleColor(.white, for: .normal)
        fileButton.backgroundColor = UIColor.clear
        fileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        fileButton.layer.cornerRadius = 18.0
        fileButton.layer.borderColor = UIColor.white.cgColor
        fileButton.layer.borderWidth = 4
        fileButton.layer.opacity = 0.7
        fileButton.addTarget(self, action: #selector(fileButtonPressed), for: .touchUpInside)
        self.view.addSubview(fileButton)
        // button layout
        fileButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        // fileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true //topからの距離を50に固定
        fileButton.widthAnchor.constraint(equalToConstant: 80).isActive = true //オブジェクトの横幅
        fileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true //オブジェクトの縦幅
        fileButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        fileButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true //オブジェクトのX座標の中心
        
        // graphButton
        graphButton.setTitle("Graph", for: .normal)
        graphButton.backgroundColor = UIColor.systemBlue
        graphButton.setTitleColor(.white, for: .normal)
        graphButton.backgroundColor = UIColor.clear
        graphButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        graphButton.layer.cornerRadius = 18.0
        graphButton.layer.borderColor = UIColor.white.cgColor
        graphButton.layer.borderWidth = 4
        graphButton.layer.opacity = 0.7
        graphButton.addTarget(self, action: #selector(graphButtonPressed), for: .touchUpInside)
        self.view.addSubview(graphButton)
        // button layout
        graphButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        // graphButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 450).isActive = true //topからの距離を50に固定
        graphButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        graphButton.widthAnchor.constraint(equalToConstant: 80).isActive = true //オブジェクトの横幅
        graphButton.heightAnchor.constraint(equalToConstant: 60).isActive = true //オブジェクトの縦幅
        graphButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        // graphButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    // カメラボタンが押された際の挙動を記述
    @objc func cameraButtonPressed() {
        // インスタンス化
        let cameraAViewController = CameraAViewController()
        // self.present(secondViewController, animated: true, completion: nil)
        navigationController?.pushViewController(cameraAViewController, animated: true)
    }
    // ファイルボタンが押された際の挙動を記述
    @objc func fileButtonPressed() {
        // インスタンス化
        let fileAViewController = FileAViewController()
        // self.present(thirdViewController, animated: true, completion: nil)
        navigationController?.pushViewController(fileAViewController, animated: true)

    }
    // グラフの表示
    @objc func graphButtonPressed() {
        let graphAViewController = GraphAViewController()
        // self.present(graphBViewController, animated: true, completion: nil)
        // no such fileと怒られてしまったので、navugationで遷移を実装してみる
        navigationController?.pushViewController(graphAViewController, animated: true)
    }
}
