BluetoothChat iOS Codebase
=====================

BluetoothChat is a Bluetooth Low Energy (BLE) powered chatting app. Support iOS9+


Setup
-----

Run `pod instsall` to install the Pod libraries.

Development
-----------

Open `BluetoothChat.xcworkspace` to start developing.

Testing
-------



Features
========

- Chat with multiple people in your area with a global chatroom
- Supports sending text and emojis
- Get notified when people join and leave the chatroom
- Delete your chat history any time
- Optimized for iPhone & iPad
- Optimized for Portrait & Landscape mode


Pipeline
--------

- Typing indicators
- Push notifications
- Sending multimedia data
- Background scanning
- Unit and UI tests

Tradeoffs
=========

Scanning
--------

Scanning and advertising is expensive yet we want it easy for users to find each other. The most expensive solution is to constantly scan for devices but that will drain the battery fast. The least expensive solution is to have the user initiate a scan but that results in a lackluster use experience. The current solution is a hybrid method conserving battery while making it easy for users to seamlessly find each other.

- On launch, starts scanning for 60 seconds
- Every minute, scans for 3 seconds
- User can manually initiate a scan for 10 seconds at any time

Sending
-------

BLE can only send/receive a limited amount of bytes at one time based on the device. Currently the app chunks a message into sending a conservative 20 bytes at a time.


Problem
-------

1. In the background mode, the peripherals will be stopped adverising. So, notification sending cannot alert to other devices, although the functionality is ready
The full problem is here http://stackoverflow.com/questions/20427230/core-bluetooth-advertise-and-scan-in-the-background. I will take time in the future to check and find a solution for it.

2. I am considering the message can be encrypted, however the amout of data size will increase, it can make slow transition data. Basiclly, I will turn off this functionality, turn on later.


Link Download Demove
-------------
An application uploaded to Diawi will be available for installation for up to 2 weeks after the last access. For 24 hours need for the first time.
http://install.diawi.com/a9DbAx

