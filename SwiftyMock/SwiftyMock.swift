//
//  SwiftyMock.swift
//  WeChatMVC
//
//  Created by PromeYang on 16/4/15.
//  Copyright © 2016年 PromeYang. All rights reserved.
//

import Foundation

class SwiftyMock: NSObject {
    static let sharedInstance = SwiftyMock()
    let nicknameList : [String:[String]]?
    let textList : [String:[String]]?
    let avatarList : [String]
    var instanceList = [AnyObject]()
    
    private override init() {
        let nicknameListPath = NSBundle.mainBundle().pathForResource("nicknameList", ofType: "json", inDirectory: "")
        let textListPath = NSBundle.mainBundle().pathForResource("textList", ofType: "json", inDirectory: "")
        let avatarListPath = NSBundle.mainBundle().pathForResource("avatarList", ofType: "json", inDirectory: "")
        if let readData = NSData(contentsOfFile: nicknameListPath!) {
            let json : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(readData, options:NSJSONReadingOptions.AllowFragments)
            nicknameList = json as? [String:[String]]
        }
        else {
            nicknameList = nil
        }
        
        if let readData = NSData(contentsOfFile: textListPath!) {
            let json : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(readData, options:NSJSONReadingOptions.AllowFragments)
            textList = json as! [String:[String]]?
        }
        else {
            textList = nil
        }
        
        if let readData = NSData(contentsOfFile: avatarListPath!) {
            let json : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(readData, options:NSJSONReadingOptions.AllowFragments)
            avatarList = json as! [String]
        }
        else {
            avatarList = []
        }
    }
    
    func fillInstanceDatas(index: Int, mockTypes: [String : NSObject]) -> Void {
        checkTypes(instanceList[index], mockTypes: mockTypes)
    }
    
    func fillEntityDatas(entity: NSObject, mockTypes: [String : NSObject]) -> NSObject {
        checkTypes(entity, mockTypes: mockTypes)
        return entity
    }
    
    func checkTypes(instance: AnyObject, mockTypes: [String : NSObject]) -> Void {
        for (key, mockEntity) in mockTypes {
            if let mockEntity = mockEntity as? MockNickname {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchNickname(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchNickname(mockEntity), forKey: key)
                }
            }
            
            else if let mockEntity = mockEntity as? MockText {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchText(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchText(mockEntity), forKey: key)
                }
            }
            
            else if let mockEntity = mockEntity as? MockAvatar {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchAvatar(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchAvatar(mockEntity), forKey: key)
                }
            }
            
            else if let mockEntity = mockEntity as? MockNumber {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchNumber(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchNumber(mockEntity), forKey: key)
                }
            }
                
            else if let mockEntity = mockEntity as? MockBool {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchBool(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchBool(mockEntity), forKey: key)
                }
            }
                
            else if let mockEntity = mockEntity as? MockDate {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchDate(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchDate(mockEntity), forKey: key)
                }
            }
                
            else if let mockEntity = mockEntity as? MockTag {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchTag(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchTag(mockEntity), forKey: key)
                }
            }
            
            else {
                if let (rule, property) = matchArray(key){
                    let dataList = fetchArray(rule, afunc: { () -> AnyObject in
                        return self.fetchEntity(mockEntity)
                    })
                    instance.setValue(dataList, forKey: property)
                }
                else {
                    instance.setValue(fetchEntity(mockEntity), forKey: key)
                }
            }
        }
    }
    
    func fetchEntity(mockEntity: NSObject) -> NSObject {
        return mockEntity.mockEntity()
    }
    
    func fetchNickname(mockEntity: MockNickname) -> String {
        let randomTarget: Int
        if let count = mockEntity.count {
            randomTarget = count
            return fetchNicknameData(randomTarget)
        }
        
        if let min = mockEntity.min {
            randomTarget = fetchRandom(range: NSMakeRange(min, 10-min))
            return fetchNicknameData(randomTarget)
        }
        
        if let max = mockEntity.max {
            randomTarget = fetchRandom(range: NSMakeRange(1, max))
            return fetchNicknameData(randomTarget)
        }
        
        if let range = mockEntity.range {
            randomTarget = fetchRandom(range: range)
            return fetchNicknameData(randomTarget)
        }
        
        randomTarget = fetchRandom(range: NSMakeRange(1, 10))
        return fetchNicknameData(randomTarget)
    }
    
    func fetchNicknameData(randomTarget: Int) -> String {
        if let nicknameList = nicknameList {
            if let list = nicknameList[String(randomTarget)] {
                return list[fetchRandom(list.count)]
            }
        }
        return ""
    }
    
    func fetchText(mockEntity: MockText) -> String {
        let randomTarget: Int
        if let count = mockEntity.count {
            randomTarget = count
            return fetchTextData(randomTarget)
        }
        
        if let min = mockEntity.min {
            randomTarget = fetchRandom(range: NSMakeRange(min, 10-min))
            return fetchTextData(randomTarget, range: NSMakeRange(min, 10-min))
        }
        
        if let max = mockEntity.max {
            randomTarget = fetchRandom(range: NSMakeRange(1, max))
            return fetchTextData(randomTarget, range: NSMakeRange(1, max))
        }
        
        if let range = mockEntity.range {
            randomTarget = fetchRandom(range: range)
            return fetchTextData(randomTarget, range: range)
        }
        
        randomTarget = fetchRandom(range: NSMakeRange(2, 200))
        return fetchTextData(randomTarget, range: NSMakeRange(2, 200))
    }
    
    func fetchTextData(randomTarget: Int, range: NSRange? = nil) -> String {
        if let textList = textList {
            if let list = textList[String(randomTarget)] {
                return list[fetchRandom(list.count)]
            }
            else {
                if let range = range {
                    let _randomTarget = fetchRandom(range: range)
                    return fetchTextData(_randomTarget, range: range)
                }
            }
        }
        return ""
    }
    
    
    func fetchNumber(mockEntity: MockNumber) -> NSNumber {
        if let count = mockEntity.count {
            let location = Int(pow(10.0, Double(count-1)))
            let length = Int(pow(10.0, Double(count)) - pow(10.0, Double(count-1)) - 1)
            return fetchRandom(range: NSMakeRange(location, length))
        }
        
        if let min = mockEntity.min {
            return fetchRandom(range: NSMakeRange(min, Int.max - min))
        }
        
        if let max = mockEntity.max {
            return fetchRandom(range: NSMakeRange(0, max))
        }
        
        if let range = mockEntity.range {
            return fetchRandom(range: range)
        }

        return fetchRandom()
    }
    
    func fetchAvatar(mockEntity: MockAvatar) -> String {
        let count = avatarList.count
        let random = fetchRandom(count)
        if random >= count {
            return ""
        }
        return avatarList[random]
    }
    
    func fetchBool(mockEntity: MockBool) -> Bool {
        return fetchRandom(2) == 0 ? false : true
    }
    
    func fetchDate(mockEntity: MockDate) -> NSDate {
        return NSDate(timeIntervalSinceNow: -1 * Double(fetchRandom(range: NSMakeRange(1, 365 * 24 * 60 * 60))))
    }
    
    func fetchTag(mockEntity: MockTag) -> String {
        let tagList = ["爱情","喜剧","动画","剧情","科幻","动作","经典","悬疑","青春","犯罪","惊悚","文艺","纪录片","搞笑","励志","恐怖","战争","短片","美国","日本","香港","英国","中国","法国","韩国","台湾","德国","意大利","旅行","摄影","影视","音乐","文学","游戏","动漫","运动","戏曲","桌游","怪癖","健康","美食","宠物","美容","化妆","护肤","服饰","公益","家庭","育儿","汽车","淘宝","二手","团购","数码","品牌","文具","求职","租房","留学","出国","理财","传媒","创业","考试","设计","手工","展览","曲艺","舞蹈","雕塑","纹身","人文","社科","自然","建筑","国学","语言","宗教","哲学","软件","硬件","互联网","恋爱","心情","心理学","星座","塔罗","LES","GAY","吐槽","笑话","直播","八卦","发泄","商业","投资","营销","广告","股票","企业史","策划"]
        return tagList[fetchRandom(tagList.count)]
    }
    
    func fetchRandom(count: Int? = nil , range: NSRange? = nil) -> Int {
        if let count = count {
            return Int(arc4random_uniform(UInt32(count)))
        }
        if let range = range {
            return Int(arc4random_uniform(UInt32(range.length))) + range.location
        }
        return 0
    }
    
    func fetchArray(rule: String, afunc: () -> AnyObject) -> NSArray {
        var dataList = [AnyObject]()
        if rule.containsString("-") {
            let subRules = rule.componentsSeparatedByString("-")
            let random = fetchRandom(range: NSMakeRange(Int(subRules[0])!, Int(subRules[1])! - Int(subRules[0])! + 1 ))
            for _ in 1...random {
                dataList.append(afunc())
            }
        }
        else {
            if let count = Int(rule) {
                if count == 0 {
                    return dataList
                }
                for _ in 1...count {
                    dataList.append(afunc())
                }
            }
            else {
                let random = fetchRandom(range: NSMakeRange(0, 5))
                for _ in 0...random {
                    dataList.append(afunc())
                }
            }
        }
        return dataList
    }
    
    func matchArray(input: String) -> (String, String)? {
        if let regex = regexMaker("\\[.*\\]") {
            if let res = regex.firstMatchInString(input, options: [], range: NSMakeRange(0, input.characters.count)){
                let match = (input as NSString).substringWithRange(res.range)
                let key = (input as NSString).substringWithRange(NSMakeRange(0, res.range.location))
                let rule = (match as NSString).substringWithRange(NSMakeRange(1, match.characters.count-2))
                return (rule, key)
            }
        }
        return nil
        
    }
    
    func regexMaker(pattern: String) -> NSRegularExpression? {
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        return regex
    }

}

public class MockEntity: NSObject {

}

public class MockNickname: MockEntity {
    let count: Int?
    let min: Int?
    let max: Int?
    let range: NSRange?
    
    init(count: Int?, min: Int?, max: Int?, range: NSRange?) {
        self.count = count
        self.min = min
        self.max = max
        self.range = range
        super.init()
    }

}

public class MockText: MockEntity {
    let count: Int?
    let min: Int?
    let max: Int?
    let range: NSRange?
    
    init(count: Int?, min: Int?, max: Int?, range: NSRange?) {
        self.count = count
        self.min = min
        self.max = max
        self.range = range
        super.init()
    }
    
}

public class MockNumber: MockEntity {
    let count: Int?
    let min: Int?
    let max: Int?
    let range: NSRange?
    
    init(count: Int?, min: Int?, max: Int?, range: NSRange?) {
        self.count = count
        self.min = min
        self.max = max
        self.range = range
        super.init()
    }
    
}

public class MockAvatar: MockEntity {
    let size: Int?
    
    init(size: Int? = nil) {
        self.size = size
        super.init()
    }
    
}

public class MockBool: MockEntity {
    
}

public class MockDate: MockEntity {
    
}

public class MockTag: MockEntity {
    
}

extension NSObject{
    
    class func mockData(mockTypes: [String : NSObject]?, length: Int, callbackBlock: (instanceList: [AnyObject]) -> Void) -> Void {
        
        let mock = SwiftyMock.sharedInstance;
        
        mock.instanceList = []
        
        for index in 0..<length {
            let _mockTypes : [String : NSObject]
            let instance = self.init()
            mock.instanceList.append(instance)
            if let mockTypes = mockTypes {
                _mockTypes = mockTypes
            }
            else {
                if let mockTypes = instance.mockTypes() {
                    _mockTypes = mockTypes
                }
                else {
                    _mockTypes = [:]
                    assert(false, "请输入mockTypes参数或者重写mockTypes方法")
                }
            }
            mock.fillInstanceDatas(index, mockTypes: _mockTypes)
        }
        
        callbackBlock(instanceList: mock.instanceList)
    }
    
    func mockEntity() -> NSObject {
        let mock = SwiftyMock.sharedInstance;
        
        if let mockTypes = self.mockTypes() {
            mock.fillEntityDatas(self, mockTypes: mockTypes)
        }
        else {
            assert(false, "内嵌的entity必须重写mockTypes方法")
        }
        return self
    }
    
    func mockTypes() -> [String : NSObject]? {
        return nil
    }
    
}

