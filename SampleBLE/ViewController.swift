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
    var characteristic:CBCharacteristic!
    var service:CBMutableService!
    
    var delegate:PeripheralManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            NSLog("SWAdvertising ON")
            setupService()
        } else {
            NSLog("SWAdvertising OFF")
            // アドバタイズを停止する
            self.manager.stopAdvertising()
        }
    }

    /*
     Serviceの設定
    */
    func setupService(){
        NSLog("setupService")
        
        // キャラスタリスティックの設定
        var charUUID = CBUUID.UUIDWithString(CharacteristicUUID)
        var val:Byte = 0x10
        
        self.characteristic = CBMutableCharacteristic(
            type: charUUID
            , properties: CBCharacteristicProperties.Read
            , value: NSData(bytes: &val, length: 1)
            , permissions: CBAttributePermissions.Readable)
        
        // Serviceの設定
        var serviceUUID = CBUUID.UUIDWithString(ServiceUUID)
        self.service = CBMutableService(type: serviceUUID, primary: true)
        
        // CBPeripheralManagerに登録
        self.service.characteristics = [self.characteristic]
        self.manager.addService(self.service)
    }
}

