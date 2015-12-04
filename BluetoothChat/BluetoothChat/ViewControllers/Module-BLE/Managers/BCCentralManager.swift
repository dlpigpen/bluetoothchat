//
//  BCCentralManager.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/2/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import Foundation
import CoreBluetooth
import CocoaLumberjack
import AFDateHelper

// MARK: - Properties

final class BCCentralManager: NSObject {

    var centralManager: CBCentralManager!
    var discoveredPeripherals: [CBPeripheral]!
    var dataStorage: [NSUUID: [CBUUID: NSMutableData]]!
    var timer: NSTimer?

    // MARK: Delegate

    weak var delegate: BCChatRoomProtocol?

    // MARK: Initializer

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        discoveredPeripherals = []
        dataStorage = [:]
    }
}

// MARK: - Public Methods

extension BCCentralManager {

    func startScanning(s: Double, indicate: Bool = true) {
        DDLogInfo("Central started scanning for \(s) seconds")
        centralManager.scanForPeripheralsWithServices([SERVICE_CHAT_UUID], options: nil)
        if indicate {
            delegate?.didStartScanning()
        }

        // Central scans for some time and then stops
        delay(s) {
            self.stopScanning()
        }
    }

    func startScanningFromTimer(timer: NSTimer) {
        if timer.userInfo is Double {
            startScanning(timer.userInfo as! Double, indicate: false)
        }
    }

    func stopScanning() {
        DDLogInfo("Central stopped scanning")
        centralManager.stopScan()
        delegate?.didFinishScanning()
    }
}

// MARK: - Private Methods

extension BCCentralManager {

    private func cleanup(peripheral: CBPeripheral) {
        if peripheral.state != .Connected {
            return
        }

        DDLogDebug("Central cleaning up connections")
        if let services = peripheral.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.isNotifying {
                            if characteristic.UUID == CHARACTERISTIC_MESSAGE_UUID || characteristic.UUID == CHARACTERISTIC_NAME_UUID {
                                peripheral.setNotifyValue(false, forCharacteristic: characteristic)
                            }
                        }
                    }
                }
            }
        }

        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - Delegates

// MARK: CBCentralManagerDelegate

extension BCCentralManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
            case .PoweredOn:
                DDLogDebug("Central is powered ON")
            default:
                DDLogWarn("Central is powered OFF")
                if let timer = timer {
                    timer.invalidate()
                }
                
                
                ///--reset all properties to start for the next time
                UIApplication.presentAlert(title: "Bluetooth is Off", message: "Please turn on Bluetooth for BluetoothChat to communicate with other devices")
                delegate?.removeAllUser()
                discoveredPeripherals = []
                dataStorage = [:]
                
                return
        }

        // Central is ON so start scanning for 60 seconds
        startScanning(5)

        // Repeat scanning every minute for 3 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "startScanningFromTimer:", userInfo: 3, repeats: true)
    }

    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        DDLogDebug("Central discovered \"\(BCTranslator.peripheralName(peripheral))\" (State: \(BCTranslator.peripheralState(peripheral)), RSSI: \(RSSI))")

        // Store newly discovered peripheral and connect to it
        if discoveredPeripherals.indexOf(peripheral) == nil {
            discoveredPeripherals.append(peripheral)

            DDLogInfo("Central connecting to \"\(BCTranslator.peripheralName(peripheral))\"")
            centralManager.connectPeripheral(peripheral, options: nil)
        }
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        DDLogInfo("Central connected to \"\(BCTranslator.peripheralName(peripheral))\"")

        // Initialize empty data for peripheral and start looking for services
        dataStorage[peripheral.identifier] = [:]
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_CHAT_UUID])
    }

    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        DDLogInfo("Central disconnected from \"\(BCTranslator.peripheralName(peripheral))\"")

        // Remove peripheral and corresponding data from memory
        discoveredPeripherals.removeObject(peripheral)
        dataStorage.removeValueForKey(peripheral.identifier)
        delegate?.userLeft(peripheral.identifier)
    }

    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        if let error = error {
            DDLogError("Central failed to connect to \"\(BCTranslator.peripheralName(peripheral))\". Error: \(error.localizedDescription)")
        }
        cleanup(peripheral)
    }
}

// MARK: CBPeripheralDelegate

extension BCCentralManager: CBPeripheralDelegate {

    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let error = error {
            DDLogError("Central encountered error discovering services: \(error.localizedDescription)")
            cleanup(peripheral)
            return
        }

        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([CHARACTERISTIC_MESSAGE_UUID, CHARACTERISTIC_NAME_UUID], forService: service)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let error = error {
            DDLogError("Central encountered error discovering characteristics: \(error.localizedDescription)")
            cleanup(peripheral)
            return
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics {

                // Found desired characteristics on peripheral so subscribe to it
                if characteristic.UUID == CHARACTERISTIC_MESSAGE_UUID || characteristic.UUID == CHARACTERISTIC_NAME_UUID {
                    DDLogDebug("Central subscribed to \"\(BCTranslator.characteristicName(characteristic))\" on \"\(BCTranslator.peripheralName(peripheral))\"")
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let error = error {
            DDLogError("Central encountered error while updating notification state: \(error.localizedDescription)")
            cleanup(peripheral)
            return
        }

        if characteristic.UUID == CHARACTERISTIC_MESSAGE_UUID || characteristic.UUID == CHARACTERISTIC_NAME_UUID {
            if characteristic.isNotifying {
                DDLogDebug("Central will be notified by \"\(BCTranslator.characteristicName(characteristic))\" on \"\(BCTranslator.peripheralName(peripheral))\"")
            } else {
                DDLogDebug("Central stopped getting notified by \"\(BCTranslator.characteristicName(characteristic))\" on \"\(BCTranslator.peripheralName(peripheral))\". Disconnecting")
                centralManager.cancelPeripheralConnection(peripheral)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let error = error {
            DDLogError("Central encountered error while retrieving updated value: \(error.localizedDescription)")
            cleanup(peripheral)
            return
        }

        guard let data = characteristic.value else {
            DDLogWarn("Central received empty data from \"\(BCTranslator.characteristicName(characteristic))\" on \"\(BCTranslator.peripheralName(peripheral))\"")
            return
        }

        // Detected EOM string in last chunk of data sent
        if let dataString = String(data: data, encoding: NSUTF8StringEncoding),
               dataStore = dataStorage[peripheral.identifier]![characteristic.UUID]
           where dataString == "EOM"
        {
            // Received a message data blob
            if characteristic.UUID == CHARACTERISTIC_MESSAGE_UUID {
                receiveMessageData(dataStore, peripheral: peripheral)

            // Received a name data blob
            } else if characteristic.UUID == CHARACTERISTIC_NAME_UUID {
                receiveNameData(dataStore, peripheral: peripheral)
            }
            dataStorage[peripheral.identifier]![characteristic.UUID] = NSMutableData()

        } else {
            appendDataChunk(data, peripheral: peripheral, characteristic: characteristic)
        }
    }
}

// MARK: - Helper Methods

extension BCCentralManager {

    private func receiveMessageData(dataStore: NSData, peripheral: CBPeripheral) {
        if let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(dataStore),
            message = dataDictionary["message"],
            name = dataDictionary["name"],
            udid = dataDictionary["udid"],
            udidreceive = dataDictionary["udidreceive"]
        {
            let message = message as! String
            let name = name as! String
            let timestamp = NSDate().toString()
            let udid = udid as! String
            let udidreceive = udidreceive as! String

            let messageObject = BCMessage(message: message, name: name, isSelf: false, isStatus: false, timestamp: timestamp, isRead: false, peripheralID: NSUUID(UUIDString: udid), udidreceive: udidreceive)
            
            //store database. only insert if corrrect address
            if Common().makeUUID() == udidreceive {
                let chatModel = ChattingModel()
                chatModel.createAChatting(messageObject)
            }
            
            delegate?.updateWithNewMessage(messageObject, isStatus: false)
            DDLogInfo("Central received message: \"\(message)\" from \"\(name)\"")
        }
    }

    private func receiveNameData(dataStore: NSData, peripheral: CBPeripheral) {
        if let name = String(data: dataStore, encoding: NSUTF8StringEncoding) {
            delegate?.userJoined(name, peripheralID: peripheral.identifier)
            DDLogInfo("Central received name: \"\(name)\"")
        }
    }

    private func appendDataChunk(data: NSData, peripheral: CBPeripheral, characteristic: CBCharacteristic) {

        // Append data chunks to local data storage for that peripheral and characteristic
        // Once the EOM string is detected, we can unwrap the whole data object
        if let dataStore = dataStorage[peripheral.identifier]![characteristic.UUID] {
            dataStore.appendData(data)
            dataStorage[peripheral.identifier]![characteristic.UUID] = dataStore
        } else {
            dataStorage[peripheral.identifier]![characteristic.UUID] = NSMutableData(data: data)
        }
        DDLogDebug("Central received chunk \"\(data)\" from \"\(BCTranslator.characteristicName(characteristic))\" on \"\(BCTranslator.peripheralName(peripheral))\"")
    }
}