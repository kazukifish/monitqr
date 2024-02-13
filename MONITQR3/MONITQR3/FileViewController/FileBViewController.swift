//
//  FileBViewController.swift
//  MONITQR3
//
//  Created by 出田和毅 on 2023/10/24.
//

import UIKit
import Foundation

class FileBViewController: UIViewController {

    let textView = UITextView()
    let fileOpenButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewの背景色
        view.backgroundColor = .white
        
        fileOpenButton.setTitle("File Open", for: .normal)
        fileOpenButton.backgroundColor = UIColor.white
        fileOpenButton.setTitleColor(.blue, for: .normal)
        fileOpenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        fileOpenButton.layer.cornerRadius = 15.0
        fileOpenButton.layer.borderColor = UIColor.blue.cgColor
        fileOpenButton.layer.borderWidth = 2
        fileOpenButton.layer.opacity = 0.8
        fileOpenButton.addTarget(self, action: #selector(openTextFileButtonTapped), for: .touchUpInside)
        self.view.addSubview(fileOpenButton)
        // button layout
        fileOpenButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        // fileOpenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true //topからの距離を50に固定
        fileOpenButton.widthAnchor.constraint(equalToConstant: 200).isActive = true //オブジェクトの横幅
        fileOpenButton.heightAnchor.constraint(equalToConstant: 50).isActive = true //オブジェクトの縦幅
        fileOpenButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        fileOpenButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true //オブジェクトのX座標の中心
    }
    // 取得データ表示ボタンタップ後の処理(ファイルオープン)
    @IBAction func openTextFileButtonTapped(_ sender: Any) {
        let fileName = "projectB.txt"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        
        // データ消去用ボタン
        let clearButton = UIButton()
        clearButton.setTitle("Clear", for: .normal)
        clearButton.backgroundColor = UIColor.white
        clearButton.setTitleColor(.blue, for: .normal)
        clearButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        clearButton.layer.cornerRadius = 15.0
        clearButton.layer.borderColor = UIColor.blue.cgColor
        clearButton.layer.borderWidth = 2
        clearButton.layer.opacity = 0.8
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        self.view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        clearButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true //topからの距離を50に固定
        clearButton.widthAnchor.constraint(equalToConstant: 60).isActive = true //オブジェクトの横幅
        clearButton.heightAnchor.constraint(equalToConstant: 30).isActive = true //オブジェクトの縦幅
        clearButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        // データファイル
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            textView.text = fileContent
        } catch {
            print("エラー: \(error)")
        }
    }
    // funcの中で別のfuncは呼び出し可能か?
}

// 拡張機能：テキストファイルに格納したデータの消去
extension FileBViewController {
    @objc func clearButtonPressed() {
        clearQRCodeData()
    }
    func clearQRCodeData() {
        let fileName = "projectB.txt"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)

        do {
            try "".write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("エラー: \(error)")
        }
    }
}
