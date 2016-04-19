# SwiftyMock

SwiftyMock 是 一个提供数据自动生成的插件

## 开始之前

项目开发中, 许多场景需要实例化一个类, 并把数据写入类中对应的属性, 要完成这样一个需求, 往往需要各种支持, 例如说接口支持, 数据支持, 增加了开发成本.

SwiftyMock 就是为了解决这样一个痛点而生, 开发者只需要通过 CocoaPods 导入这个插件, 就可以快速的实现以上功能.

## 快速开始

直接把项目文件克隆到本地, 然后添加到工程中, 包括 `Support Files` 中的文件

## 如何使用

SwiftyMock 扩展了 `NSObject` 类, 提供一个静态方法 `mockData`, 继承于 `NSObject` 的类可以调用该静态方法

```
class func mockData(mockTypes: [String : MockEntity]?, length: Int, callbackBlock: (instanceList: [AnyObject]) -> Void) -> Void
```

参数 | 类型 | 说明
----- | ----- | ---------------
mockTypes | [String : MockEntity]? | 指定要生成的数据规则, 字典的`key`对应着类中的属性, `value`对应着数据类
length | Int | 指定要生成的数据长度, 例如 `length: 10` 表示生成10条数据
callbackBlock | (instanceList: [AnyObject]) -> Void) | 指定生成数据后的回调, `instanceList` 是已经把数据实例化之后的对象实例数组

### 1.重写mockTypes方法, 返回数据规则

```
class aClass : NSObject {
    var name : String?
    var title : String?
    var avatar : String?
    var number: NSNumber?
    // 重写mockTypes方法
    override func mockTypes() -> [String : MockEntity]? {
        return [
            "name": MockNickname(count: nil, min: nil, max: nil, range: nil),
            "title": MockText(count: 2, min: nil, max: nil, range: nil),
            "avatar": MockAvatar(),
            "number": MockNumber(count: 2, min: nil, max: nil, range: nil)
        ]
    }
}
// 调用静态方法 mockData
aClass.mockData(nil ,length: 10, callbackBlock: { instanceList in
    for item in instanceList{
		// TODO
    }
})
```

### 2.传入mockTypes参数, 提供数据规则

```
class aClass : NSObject {
    var name : String?
    var title : String?
    var avatar : String?
    var number: NSNumber?
}
// 调用静态方法 mockData
aClass.mockData(
    [
        "name": MockNickname(count: nil, min: nil, max: nil, range: nil),
        "title": MockText(count: 2, min: nil, max: nil, range: nil),
        "avatar": MockAvatar(),
        "number": MockNumber(count: 2, min: nil, max: nil, range: nil)
    ] ,length: 10, callbackBlock: { instanceList in
        for item in instanceList{
            // TODO
        }
})
```

## 数据类

所有的数据类都继承于 `MockEntity`

### MockNickname

生成 `String` 类型的数据, 生成指定规则的昵称

```
MockNickname(count: Int?, min: Int?, max: Int?, range: NSRange?)
```

#### rules

规则 | 类型 | 说明
----- | ----- | ---------------
count | Int | 生成固定长度的昵称
min | Int | 生成 >= min 长度的昵称, 昵称最大长度为10
max | Int | 生成 <= max 长度的昵称, 昵称最小长度为1
range | NSRange | 生成给定长度内的昵称


### MockText

生成 `String` 类型的数据, 生成指定规则的文本内容, 如标题, 正文文本

```
MockText(count: Int?, min: Int?, max: Int?, range: NSRange?)
```

#### rules

规则 | 类型 | 说明
----- | ----- | ---------------
count | Int | 生成固定长度的文本
min | Int | 生成 >= min 长度的文本, 昵称最大长度为200
max | Int | 生成 <= max 长度的文本, 昵称最小长度为1
range | NSRange | 生成给定长度内的文本

### MockNumber

生成 `NSNumber` 类型的数据, 生成指定规则的数值

```
MockNumber(count: Int?, min: Int?, max: Int?, range: NSRange?)
```

#### rules

规则 | 类型 | 说明
----- | ----- | ---------------
count | Int | 生成固定位数的数值, 例如 `count=2` 表示生成 `10~99` 的数值
min | Int | 生成 >= min 的数值, 最大值为 `Int.max`
max | Int | 生成 <= max 的数值, 最小值为 `0`
range | NSRange | 生成指定范围内的数值

### MockAvatar

返回 `String` 类型的数据, 生成真实的头像地址

```
MockAvatar()
```

## 更新日志

1.0.0 - 支持 `MockNickname`, `MockText`, `MockNumber`, `MockAvatar` 四种数据类型

## Issues
