import Foundation

extension String
{
    var length: Int {
        get {
            return self.characters.count
        }
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    var doubleValue: Double {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number.doubleValue
        }
        return 0
    }
    
    
    func contains(s: String) -> Bool
    {
        if self .indexOf(s) == -1
        {
            return false
        }
        return  true
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character
    {
        get {
            let index = startIndex.advancedBy(i)
            return self[index]
        }
    }
    

    
    subscript (r: Range<Int>) -> String
    {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String
    {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    func indexOf(target: String) -> Int
    {
        let range = self.rangeOfString(target)
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        let startRange = self.startIndex.advancedBy(startIndex)
        
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        
        if let error = error {
            print(error.description)
        }
        let matchCount = exp!.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        
        if let error = error {
            print(error.description)
        }
        let matches = exp!.matchesInString(self, options: [], range: NSMakeRange(0, self.length))
        return matches 
    }
    
    private var vowels: [String]
    {
      get
      {
        return ["a", "e", "i", "o", "u"]
      }
    }
    
    private var consonants: [String]
    {
      get
      {
        return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
      }
    }
    
    func pluralize(count: Int) -> String
    {
        if count == 1 {
            return self
        } else {
            let lastChar = self.subString(self.length - 1, length: 1)
            let secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0...self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercaseString == "s" || (lastChar.lowercaseString == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0...self.length]
                suffix = "es"
            } else {
                prefix = self[0...self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercaseString ? suffix : suffix.uppercaseString)
        }
    }
}


extension Int {

    var f: CGFloat { return CGFloat(self) }
    
    static func random2(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }

}

extension Float {
    var f: CGFloat { return CGFloat(self) }
}

extension Double {
    var f: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    var swf: Float { return Float(self) }
}

extension UIView {
    var topF: Float{ return Float(self.frame.origin.y) }
    var rightF: Float{ return Float(self.frame.origin.x + self.frame.size.width) }
    var bottomF: Float{ return Float(self.frame.origin.y + self.frame.size.height) }
    var leftF: Float{ return Float(self.frame.origin.x) }
    var widthF: Float{ return Float(self.frame.size.width) }
    var heightF: Float{ return Float(self.frame.size.height) }
    var centerWitdhF: Float{ return Float(self.frame.size.width/2) }
    var centerHeightF: Float{ return Float(self.frame.size.height/2) }
    
    func setTopF(y:Float) {
        var frame = self.frame
        frame.origin.y = y.f
        self.frame = frame
    }
    
    func setRightF(right:Float) {
        var frame = self.frame
        frame.origin.x = right.f - self.frame.size.width
        self.frame = frame
    }
    
    
    func setHeightF(height:Float) {
        var frame = self.frame
        frame.size.height = height.f
        self.frame = frame
    }
    func setWidthF(width:Float) {
        var frame = self.frame
        frame.size.width = width.f
        self.frame = frame
    }
    
    func setLeftF(x:Float) {
        var frame = self.frame
        frame.origin.x = x.f
        self.frame = frame
    }
    
    func setBottomF(bottom:Float) {
        var frame = self.frame
        frame.origin.y = bottom.f - self.frame.size.height
        self.frame = frame
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 2.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(2*M_PI)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
        
        
    }
}

extension NSObject {
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelectorAsyncRepeats(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: true)
        return timer
    }
    
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}


private class NSTimerActor {
    var block: () -> ()
    
    init(_ block: () -> ()) {
        self.block = block
    }
    
    @objc func fire() {
        block()
    }
}


extension Double {
    var second:  NSTimeInterval { return self }
    var seconds: NSTimeInterval { return self }
    var minute:  NSTimeInterval { return self * 60 }
    var minutes: NSTimeInterval { return self * 60 }
    var hour:    NSTimeInterval { return self * 3600 }
    var hours:   NSTimeInterval { return self * 3600 }
}


extension NSTimer {
    class func new(after interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: false)
    }
    
    class func new(every interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: true)
    }
}


extension Array {
    func contains<T:AnyObject>(item:T) -> Bool {
        for element in self {
            if item === element as? T {
                return true
            }
        }
        return false
    }
}

internal extension Dictionary {
    mutating func validNull() {
            for (key, value) in self {
                if  value is NSNull
                {
                   let valueString = "" as! Value
                   self.updateValue(valueString, forKey: key as Key)
                }
            }
        }
}


extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
}


extension UIImage {
    class func imageWithImageView(image: UIImage) -> UIImage {
        let view:UIView = UIView(frame: CGRectMake(0, 0, 40, 56))
        view.backgroundColor = UIColor.clearColor()
        let imgBGView:UIImageView = UIImageView(frame: view.bounds)
        imgBGView.image = UIImage(named: "mapPin")
        imgBGView.backgroundColor = UIColor.clearColor()
        view .addSubview(imgBGView)
        
       
        
        let imgAvatar:UIImageView = UIImageView(frame: CGRectMake(5, 5, 30, 30))
        imgAvatar.image = image
        imgAvatar.backgroundColor = UIColor.clearColor()
        view .addSubview(imgAvatar)
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer .renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}



