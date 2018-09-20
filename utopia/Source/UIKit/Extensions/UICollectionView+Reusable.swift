import UIKit

public extension UICollectionView {

  func registerCell<T: UICollectionViewCell>(
    _ type: T.Type,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier)
  {
    register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
  }

  func dequeueCell<T: UICollectionViewCell>(
    _ type: T.Type = T.self,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier,
    for indexPath: IndexPath) -> T
  {
    guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
    }
    return cell
  }

  func registerSupplement<T: UICollectionReusableView>(
    _ type: T.Type,
    kind: String,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier)
  {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
  }

  func dequeueSupplement<T: UICollectionReusableView>(
    _ type: T.Type = T.self,
    kind: String,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier,
    for indexPath: IndexPath) -> T
  {
    guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unknown \(kind) type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
    }
    return view
  }

  func registerHeader<T: UICollectionReusableView>(
    _ type: T.Type,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier)
  {
    registerSupplement(T.self, kind: UICollectionView.elementKindSectionHeader)
  }

  func dequeueHeader<T: UICollectionReusableView>(
    _ type: T.Type = T.self,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier,
    for indexPath: IndexPath) -> T
  {
    return dequeueSupplement(kind: UICollectionView.elementKindSectionHeader, for: indexPath)
  }

  func registerFooter<T: UICollectionReusableView>(
    _ type: T.Type,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier)
  {
    registerSupplement(T.self, kind: UICollectionView.elementKindSectionFooter)
  }

  func dequeueFooter<T: UICollectionReusableView>(
    _ type: T.Type = T.self,
    withIdentifier reuseIdentifier: String = T.reuseIdentifier,
    for indexPath: IndexPath) -> T
  {
    return dequeueSupplement(kind: UICollectionView.elementKindSectionFooter, for: indexPath)
  }

}

public extension UICollectionReusableView {

  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
