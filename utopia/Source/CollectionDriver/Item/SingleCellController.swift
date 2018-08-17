import UIKit
import VendefyService

final class SingleCellController<CollectionCell: UICollectionViewCell & Fillable, ItemData>: CollectionItemProtocol where CollectionCell.Data == ItemData {
  
  typealias Cell = CollectionCell
  typealias Data = ItemData
  
  var cellSelected: ((Cell, Data) -> ())?
  var cellConfigure: ((Cell) -> ())?
  
  var data: ItemData
  var events = CollectionItemEvents<Data>()
  
  let height: CGFloat
  
  init(data: ItemData, height: CGFloat) {
    self.data = data
    self.height = height
  }

  // MARK: CollectionItemProtocol
  func fillCell(_ cell: CollectionCell, animated: Bool) {
    cell.fill(data)
    cellConfigure?(cell)
  }
  
  func size(constrainedTo width: CGFloat, height: CGFloat) -> CGSize {
    return CGSize(width: width, height: self.height)
  }
  
  func cellSelected(_ cell: Cell) {
    cellSelected?(cell, data)
  }
}
