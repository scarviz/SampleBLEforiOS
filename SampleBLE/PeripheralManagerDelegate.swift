//
//  PeripheralManagerDelegate.swift
//  SampleBLE
//
//  Created by scarviz on 2014/09/08.
//  Copyright (c) 2014年 scarviz. All rights reserved.
//

import CoreBluetooth

class PeripheralManagerDelegate : NSObject, CBPeripheralManagerDelegate{
    /*
    BLEの状態変更時処理
    */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!){
        if (peripheral.state == CBPeripheralManagerState.PoweredOn) {
            NSLog("state PoweredOn")
        }
    }
    
    /*
    PeripheralManager登録完了時処理
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        if error != nil {
            NSLog(error.localizedFailureReason!)
            return
        }
        
        var name = "SampleBLE"
        // アドバタイズを開始する
        peripheral.startAdvertising(
            [CBAdvertisementDataLocalNameKey:name
                , CBAdvertisementDataServiceUUIDsKey:[service.UUID]
            ])
        NSLog("start Advertising")
    }
    
    /*
    アドバタイズ開始後処理
    */
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        if error != nil {
            NSLog(error.localizedFailureReason!)
        } else {
            NSLog("DidStartAdvertising no error")
        }
    }
    
    /*
    CentralからのRead要求時処理
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveReadRequest request: CBATTRequest!) {
        // ReadでCentralに返す値(テスト用)
        var val:Byte = 0x10
        request.value = NSData(bytes: &val, length: 1)
        
        // Centralに返す
        peripheral.respondToRequest(request, withResult: CBATTError.Success)
    }
    
    /*
    CentralからのWrite要求時処理
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveWriteRequests requests: [AnyObject]!) {
        for item in requests {
            // Centralからのデータ取得
            var res = NSString(data: item.value, encoding: NSUTF8StringEncoding)
            
            // TODO:取得したデータを処理する
        }
    }
}