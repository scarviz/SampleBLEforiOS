//
//  ViewController.swift
//  SampleBLE
//
//  Created by scarviz on 2014/09/07.
//  Copyright (c) 2014年 scarviz. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    let CharacteristicUUID = "E2CC9711-C6D2-464D-AC7C-25DC963F0BDE"
    let ServiceUUID = "9E672755-C622-49E0-93B8-4BE76A97208B"
    
    var manager:CBPeripheralManager!
    var characteristic:CBMutableCharacteristic!
    var service:CBMutableService!
    
    var delegate:PeripheralManagerDelegate?
    
    @IBOutlet weak var TxtBxNotifyStr: UITextField!
    @IBOutlet weak var LblLog: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LblLog.sizeToFit()
        
        self.delegate = PeripheralManagerDelegate()
        self.manager = CBPeripheralManager(delegate: delegate, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     Switch切り替え時処理
    */
    @IBAction func onValueChanged_SWAdvertising(sender: UISwitch) {
        if sender.on{
            SetLog("SWAdvertising ON")
            setupService()
        } else {
            SetLog("SWAdvertising OFF")
            // アドバタイズを停止する
            self.manager.stopAdvertising()
        }
    }
    
    /*
     SendNotifyボタン押下時処理
    */
    @IBAction func onTouchUpInside_BtnSendNotify(sender: UIButton) {
        if self.manager == nil || self.characteristic == nil {
            SetLog("manager or characteristic is nil")
            return
        }
        
        var str = self.TxtBxNotifyStr.text
        if str == nil || str.isEmpty {
            SetLog("text is nil")
            return
        }
        
        var data = str.dataUsingEncoding(NSUTF8StringEncoding)
        // Centralにデータを通知する
        self.manager.updateValue(data, forCharacteristic: self.characteristic, onSubscribedCentrals: nil)
        SetLog("send notify")
    }

    /*
     Serviceの設定
    */
    func setupService(){
        SetLog("setupService")
        
        // キャラスタリスティックの設定
        var charUUID = CBUUID.UUIDWithString(CharacteristicUUID)
        
        // Read, Write, Notify
        var prop =
            CBCharacteristicProperties.Read
            | CBCharacteristicProperties.Write
            | CBCharacteristicProperties.Notify;
        
        // Read, Writeの権限をつける。Notifyはnilになる
        var perm =
            CBAttributePermissions.Readable
            | CBAttributePermissions.Writeable;
        
        // キャラクタリスティックの設定
        // (Readのレスポンスを固定にしない場合、ここでのvalueはnilにしておく)
        self.characteristic = CBMutableCharacteristic(
            type: charUUID
            , properties: prop
            , value: nil
            , permissions: perm )
        
        // Serviceの設定
        var serviceUUID = CBUUID.UUIDWithString(ServiceUUID)
        self.service = CBMutableService(type: serviceUUID, primary: true)
        
        // CBPeripheralManagerに登録
        self.service.characteristics = [self.characteristic]
        self.manager.addService(self.service)
    }
    
    /*
     Logの設定
    */
    func SetLog(mes : String){
        NSLog(mes)
        
        var multiStr:NSMutableString = NSMutableString()
        multiStr.setString(mes)
        
        var log = self.LblLog.text!
        if !log.isEmpty {
            multiStr.appendString("\n")
            multiStr.appendString(log)
        }
        
        self.LblLog.text = multiStr
    }
}

