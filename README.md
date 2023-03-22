# ThenFoundation



针对基础THEN进行封装, 主要通过.then链式使用

```
let data = Data()
print(data.then.hexString)

class Man: NSObject {
    var name: String = ""
}
let o = Man()
o.then.addNotification(name: NSNotification.Name("Test"), object: nil) { noti in
    print(noti.userInfo as Any)
}.force { obj in
    print(obj.name)
}.dispose()
```



## Installation

#### Cocoapods

```
pod 'ThenFoundation', :git => 'https://github.com/ghostcrying/ThenFoundation.git'
# , :tag => '1.0.0'
# 可根据tag指定使用
```



#### Carthage

```
github "ghostcrying/ThenFoundation"
```



#### Swift Package Manager

```
https://github.com/ghostcrying/ThenFoundation.git
```

