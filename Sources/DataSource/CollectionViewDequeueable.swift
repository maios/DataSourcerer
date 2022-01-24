#if canImport(UIKit)
import UIKit

public protocol CollectionViewDequeueable {
    associatedtype DequeueType
    func dequeue(in collectionView: UICollectionView, indexPath: IndexPath) -> DequeueType
}
#endif
