#if canImport(UIKit)
import UIKit

public typealias ListCell<Cell: UICollectionViewListCell, Item> = CollectionViewCell<Cell, Item>
public typealias BaseListCell<Item> = ListCell<UICollectionViewListCell, Item>
#endif
