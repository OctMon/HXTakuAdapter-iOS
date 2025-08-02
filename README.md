## 1、IOS集成步骤
### 1.1 添加SDK依赖
#### 1.1.1 pox HXSDK
```
pod 'HXSDK'
```
### 2.1 添加Taku适配器依赖
#### 2.1.1 手动下载HXTakuAdapter源码文件，添加到项目中，地址：https://github.com/octMon/HXTakuAdapter-i0S/tree/main/HXTakuAdapter-i0S-Example/HXTakuAdapter-i0S.Example

#### 2.1.2、TaKu平台上配置自定义广告平台
Adapter类名介绍
```
开屏：ATHXSplashAdapter
```
#### 2.1.3 创建自定义广告平台，填写适配器类名
#### 2.1.4 添加广告源，配置参数app_id和unit_id
开屏广告：
```
app_id = 71004
unit_id = 11111231
```
### 注意事项：

1、上线时需要将appId的值和代码位ID替换成正式的，上述的appId和代码位ID的值为测试通用的