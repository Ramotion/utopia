import Foundation

public enum Math {
  public static func lerp<T: FloatingPoint>(from: T, to: T, progress: T) -> T {
    return from + progress * (to - from);
  }
}

public enum Progress {
  
  public static func nomalizeProgress<T: FloatingPoint>(min: T, max: T, progress: T) -> T {
    let p = progress.limited(min, max)
    let current = (p - min)
    return current / (max - min)
  }
  
  public static func centeredProgress<T: FloatingPoint>(progress: T, centerRange: T) -> T {
    
    let normalProgress = progress.limited(0, 1)
    
    let p1 = (1 - centerRange)/2
    let p2 = (1 + centerRange)/2
    let centeredProgress: T
    switch progress {
    case let x where x < p1:
      centeredProgress = normalProgress / p1
    case let x where x <= p2:
      centeredProgress = 1
    case let x where x > p2:
      centeredProgress = 1 - (normalProgress - p2) / p1
    default:
      centeredProgress = 0
    }
    return centeredProgress
  }
}
