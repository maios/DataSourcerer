#if canImport(UIKit)
import UIKit

open class CollectionViewDataSource: NSObject {
    public typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    public typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>

    private var snapshot = Snapshot()
    private var dataSource: DiffableDataSource!

    private var supplementaryProviders: [String: SupplementaryProvider] = [:]

    public init(collectionView: UICollectionView) {
        super.init()
        collectionView.delegate = self
        
        dataSource = DiffableDataSource(collectionView: collectionView) { [unowned self] (collectionView, indexPath, item) in
            guard let section = self.snapshot.sectionIdentifier(containingItem: item) else { return nil }
            return section.dequeueCell(in: collectionView, indexPath: indexPath, with: item)
        }
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, elementKind, indexPath) in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return self[indexPath.section]?.headerViewProvider?.dequeue(in: collectionView, indexPath: indexPath)

            case UICollectionView.elementKindSectionFooter:
                return self[indexPath.section]?.footerViewProvider?.dequeue(in: collectionView, indexPath: indexPath)

            default:
                return self.supplementaryProviders[elementKind]?.dequeue(in: collectionView, indexPath: indexPath)
            }
        }
    }

    // MARK: DataSource
    
    public subscript(_ sectionIndex: Int) -> Section? {
        guard case 0 ..< snapshot.numberOfSections = sectionIndex else { return nil }
        return snapshot.sectionIdentifiers[sectionIndex]
    }

    public subscript(indexPath: IndexPath) -> (Section, AnyHashable)? {
        guard let section = self[indexPath.section] else { return nil }
        guard case 0 ..< snapshot.numberOfItems(inSection: section) = indexPath.item else { return nil }

        return (section, snapshot.itemIdentifiers(inSection: section)[indexPath.item])
    }

    private var _state: State = State(sections: [])
    open var state: State {
        get {
            _state
        }
        set {
            apply(state: newValue, animated: false)
        }
    }

    /// Updates the UI to reflect the state of data, optionally animates the UI changes and evaluates the `completion` handler.
    open func apply(state: State, animated: Bool = true, completion: (() -> Void)? = nil) {
        snapshot.deleteAllItems()
        snapshot.appendSections(state.sections)

        for section in state.sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        _state = state
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

    /// Provides the supplementary view for given `elementKind`.
    open func registerView<View>(
        _ view: View.Type,
        elementKind: String,
        viewConfiguration: @escaping (View) -> Void)
    where View: UICollectionReusableView {
        supplementaryProviders[elementKind] = .supplementaryProvider(for: elementKind, viewConfiguration: viewConfiguration)
    }

    /// Provides the global layout header view.
    public final func addBoundaryHeader<View>(
        _ view: View.Type,
        viewConfiguration: @escaping (View) -> Void)
    where View: UICollectionReusableView {
        registerView(
            view,
            elementKind: SupplementaryProvider.ElementKind.boundaryHeader,
            viewConfiguration: viewConfiguration)
    }

    /// Provides the global layout footer view.
    public final func addBoundaryFooter<View>(
        _ view: View.Type,
        viewConfiguration: @escaping (View) -> Void)
    where View: UICollectionReusableView {
        registerView(
            view,
            elementKind: SupplementaryProvider.ElementKind.boundaryFooter,
            viewConfiguration: viewConfiguration)
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewDataSource: UICollectionViewDelegate {

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let (section, item) = self[indexPath] else { return }
        section.cellProviders[item]?.observer.onCellSelected?()
    }

    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let (section, item) = self[indexPath] else { return }
        section.cellProviders[item]?.observer.onCellDeselected?()
    }
}
#endif
