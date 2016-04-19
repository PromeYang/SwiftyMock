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
    
    func fillInstanceDatas(index: Int, mockTypes: [String : MockEntity]) -> Void {
        checkTypes(index, mockTypes: mockTypes)
    }
    
    func checkTypes(index: Int, mockTypes: [String : MockEntity]) -> Void {
        for (key, mockEntity) in mockTypes {
            if let mockEntity = mockEntity as? MockNickname {
                instanceList[index].setValue(fetchNickname(mockEntity), forKey: key)
            }
            
            if let mockEntity = mockEntity as? MockText {
                instanceList[index].setValue(fetchText(mockEntity), forKey: key)
            }
            
            if let mockEntity = mockEntity as? MockAvatar {
                instanceList[index].setValue(fetchAvatar(mockEntity), forKey: key)
            }
            
            if let mockEntity = mockEntity as? MockNumber {
                instanceList[index].setValue(fetchNumber(mockEntity), forKey: key)
            }
        }
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
            else {
                return ""
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
    
    func fetchRandom(count: Int? = nil , range: NSRange? = nil) -> Int {
        if let count = count {
            return Int(arc4random_uniform(UInt32(count)))
        }
        if let range = range {
            return Int(arc4random_uniform(UInt32(range.length))) + range.location
        }
        return 0
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

extension NSObject{
    
    class func mockData(mockTypes: [String : MockEntity]?, length: Int, callbackBlock: (instanceList: [AnyObject]) -> Void) -> Void {
        
        let mock = SwiftyMock.sharedInstance;
        
        mock.instanceList = []
        
        for index in 0..<length {
            let _mockTypes : [String : MockEntity]
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
    
    func mockTypes() -> [String : MockEntity]? {
        return nil
    }
    
}

