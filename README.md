# iOSPushSample

This is a sample application for KiiCloud. You can test two-type push notification on your device using by this application.

* Push to App
* Push to User

This application runs on iOS 5.0 installed device or latest.

## Features:

This application uses the following features:

* User Management
  * Register with Username/Password.
  * Sign-in with an access token.

* Data Management
  * Push common feature
     * Install device token for push notification
  * "Push to App" related feature
     * Create object in user scope.
     * Update object in user scope.
     * Delete object in user scope.
     * Subscribe bucket in user scope.
     * Unsubscribe bucket in user scope.
     * Query object in user scope.
     * Retrieve bucket data using all clause.
     * Add ACL to object in user scope.
     * Delete ACL to object in user scope.
  * "Push to User" related feature
     * Create topic in user scope.
     * Update topic in user scope.
     * Delete topic in user scope.
     * Subscribe topic in user scope.
     * Unsubscribe topic in user scope.
     * Send message to topic in user scope.
     * Add ACL to object in user scope.
     * Delete ACL to object in user scope.

## Requirements:

* iPhone/iPad (iOS 5.0 or later)
* Xcode (version 4.2 or later)
* CocoaPods

## Previous arrangement:

* Create "Production/Development Push SSL Certificate" on [iOS Provisioning Portal](https://developer.apple.com/ios/manage/overview/index.action) and export it as p12.

## How to Install:

### 1. Open kii_rest

```bash
cd kii_rest
```

### 2. Edit setting.ini

  * app-id: Replace with your app-id created on developer portal.
  * app-key: Replace with your app-key created on developer portal.
  * client-id: Replace with your clietn-id created on developer portal.
  * client-secret: Replace with your clietn-secret created on developer portal.
  * host:
      * If your app domain is US: replace with api.kii.com
      * If your app domain is JP: replace with api-jp.kii.com.
  * apns-dev-cert-name: Replace with your Development Push SSL certificate name.
  * apns-dev-cert-pass: Replace with your Development Push SSL certificate password.
  * apns-production-cert-name: Replace with your Production Push SSL certificate name.
  * apns-production-cert-pass: Replace with your Production Push SSL certificate password.

### 3. Run setting script

```bash
python setup_push.py
```

### 4. Build and install application

* Execute `pod install` on project root directory
* Open iOSPushSample.xcworkspace
* Open /Supporting Files/iOSPushSample-Prefix.pch
* Edit APPID/APPKEY created on developer portal
* Bulid and launch application on iOS devices

### NOTE:

kii_rest/setting.ini will be used to generate application property on build. After update setting.ini, make sure to run setup_push.py and rebuild application.

## Send message to app scope topic:

```bash
cd kii_rest
python sendmessage.py
```

* Message can be cofitured by editing property 'push-message' in setting.ini

## Trigger event on app scope bucket:

```bash
cd kii_rest
python create_app_bucket_object.py.py
```

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/KiiPlatform/iospushsample/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

