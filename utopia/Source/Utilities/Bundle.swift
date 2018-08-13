import Foundation

public extension Bundle {
  
  public var appName: String {
    return infoDictionary?["CFBundleName"] as! String
  }
  
  public var bundleId: String {
    return bundleIdentifier!
  }
  
  public var versionNumber: String {
    return infoDictionary?["CFBundleShortVersionString"] as! String
  }
  
  public var buildNumber: String {
    return infoDictionary?["CFBundleVersion"] as! String
  }
}
