## 1、IOS集成步骤
### 1.1 添加SDK依赖
#### 1.1.1 pox HXSDK
```
pod 'HXSDK'
```
### 2.2 添加Taku适配器依赖
#### 2.2.1 手动下载HXTakuAdapter源码文件，添加到项目中，地址：https://github.com/OctMon/HXTakuAdapter-iOS/tree/main/HXTakuAdapter-iOS-Example/HXTakuAdapter-iOS-Example

### 2.2.2、TaKu平台上配置自定义广告平台
Adapter类名介绍
```
开屏：ATHXSplashAdapter
```
### 2.2.3 创建自定义广告平台，填写适配器类名
### 2.2.4 添加广告源，配置参数app_id和unit_id
开屏广告：
```
app_id = 71003
unit_id = 10000001
```