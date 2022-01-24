#if canImport(UIKit)

import UIKit

public struct CollectionViewCell<Cell: UICollectionViewCell, Item> {
    public typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>

    internal let cellRegistration: CellRegistration
    internal let observer = CollectionViewCellObserver()

    /// Creates a new instance of CollectionViewCell with given cell registration.
    public init(cellRegistration: UICollectionView.CellRegistration<Cell, Item>) {
        self.cellRegistration = cellRegistration
    }

    /// Creates a new instance of CollectionViewCell with given cell configuration.
    public init(_ cellConfiguration: @escaping CellRegistration.Handler) {
        self.init(cellRegistration: CellRegistration(handler: cellConfiguration))
    }

    /// Evaluates the given closure when the receive's cell is selected.
    public func onSelected(_ action: @escaping () -> Void) -> Self {
        observer.onCellSelected = action
        return self
    }

    public func onDeselected(_ action: @escaping () -> Void) -> Self {
        observer.onCellDeselected = action
        return self
    }
}

/// Type-erased CollectionViewCell.
internal struct CellProvider: CollectionViewDequeueable {
    private let cellProvider: (UICollectionView, IndexPath) -> UICollectionViewCell
    let observer: CollectionViewCellObserver

    init<Item: Hashable, Cell: UICollectionViewCell>(
        item: Item,
        cell: CollectionViewCell<Cell, Item>
    ) {
        cellProvider = { (collectionView, indexPath) in
            collectionView.dequeueConfiguredReusableCell(using: cell.cellRegistration, for: indexPath, item: item)
        }
        observer = cell.observer
    }

    func dequeue(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        cellProvider(collectionView, indexPath)
    }
}

// MARK: Observer
internal class CollectionViewCellObserver {
    var onCellSelected: (() -> Void)?
    var onCellDeselected: (() -> Void)?
}
#endif
