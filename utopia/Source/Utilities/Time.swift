import Foundation


extension TimeInterval {
  public static var oneFrame: TimeInterval {
    return 1/60.0
  }
  
  public static var halfSecond: TimeInterval {
    return 1/2.0
  }
  
  public static var oneSecond: TimeInterval {
    return 1
  }
  
  public static var oneDay: TimeInterval {
    return 60 * 60 * 24
  }
  
  public static var twoDays: TimeInterval {
    return 60 * 60 * 24 * 2
  }
  
  public static var treeDays: TimeInterval {
    return 60 * 60 * 24 * 3
  }
  
  public static var oneWeek: TimeInterval {
    return 60 * 60 * 24 * 7
  }
  
  public static var oneMonth: TimeInterval {
    return 60 * 60 * 24 * 30
  }
  
  public static var oneYear: TimeInterval {
    return 60 * 60 * 24 * 366
  }
}

public func delay(_ delay: Double, _ closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
