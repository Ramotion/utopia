import Foundation

public struct DateUtilities {
  
  public static func agoFormat(_ date: Date) -> String? {
    let dateFormatter = DateComponentsFormatter()
    dateFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
    dateFormatter.allowedUnits = [.second, .minute, .year, .month, .day, .hour]
    dateFormatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.dropAll
    let rerult = dateFormatter.string(from: date, to: Date())
    return rerult
  }
  
  public static func postedDateFormat(fromDate: Date, toDate: Date) -> String {
    let calendar = Calendar.current
    let flags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
    let components: DateComponents = calendar.dateComponents(flags, from: fromDate, to: toDate)
    
    func checkCalendarComponent(_ component: Int?, _ suffix: String) -> String? {
      guard let dateComponent = component, dateComponent != 0, dateComponent != 0 else { return nil }
      return String(dateComponent) + suffix
    }
    
    if let ago = checkCalendarComponent(components.year, "y") { return ago }
    if let ago = checkCalendarComponent(components.month, "mo") { return ago }
    if let ago = checkCalendarComponent(components.day, "d") { return ago }
    if let ago = checkCalendarComponent(components.hour, "h") { return ago }
    if let ago = checkCalendarComponent(components.minute, "m") { return ago }
    if let ago = checkCalendarComponent(components.second, "s") { return ago }
    return "1s"
  }
  
  fileprivate static let durationDateFormatter: DateFormatter = DateUtilities.mkDurationDateFormatter()
  fileprivate static func mkDurationDateFormatter() -> DateFormatter {
    let durationDateFormatter = DateFormatter()
    durationDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    durationDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm:ss", options: 0, locale: nil)
    
    return durationDateFormatter
  }
  
  static public func calendarDateString(_ date: Date) -> String {
    let dateFormater = DateFormatter()
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormater.dateFormat = "dd MM, yyyy"
    let result = dateFormater.string(from: date)
    return result
  }
  
  static public func getAppDateInstallation() -> Date? {
    do {
      let bundleRoot = Bundle.main.bundlePath // e.g. /var/mobile/Applications/<GUID>/<AppName>.app
      let manager = FileManager.default
      let attrs = try manager.attributesOfItem(atPath: bundleRoot)
      return attrs[FileAttributeKey.creationDate] as? Date
    } catch {
      return nil
    }
  }
}
