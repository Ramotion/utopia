import UIKit

public extension UITableView {

  func registerCell<T: UITableViewCell>(_ type: T.Type, withIdentifier reuseIdentifier: String = T.reuseIdentifier) {
    register(T.self, forCellReuseIdentifier: reuseIdentifier)
  }

  func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = T.reuseIdentifier,
    for indexPath: IndexPath) -> T {
    
    guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
    }
    return cell
  }
}

public extension UITableViewCell {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
}
