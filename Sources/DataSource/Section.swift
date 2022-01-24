#if canImport(UIKit)
import UIKit

open class Section: Hashable {
    public let sectionIdentifier: AnyHashable

    internal private(set) var cellProviders: [AnyHashable: CellProvider] = [:]
    internal private(set) var items: [AnyHashable] = []

    internal private(set) var headerViewProvider: SupplementaryProvider?
    internal private(set) var footerViewProvider: SupplementaryProvider?

    public init(sectionIdentifier: AnyHashable) {
        self.sectionIdentifier = sectionIdentifier
    }

    public init(sectionIdentifier: AnyHashable, @ForEach.Builder _ forEach: () -> ForEach) {
        self.sectionIdentifier = sectionIdentifier
        apply(forEach)
    }

    // MARK: Hash

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sectionIdentifier)
    }

    public static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.sectionIdentifier == rhs.sectionIdentifier
    }

    // MARK: DataSource

    open func apply(@ForEach.Builder _ forEach: () -> ForEach) {
        let forEach = forEach()
        items = forEach.items
        cellProviders = forEach.cellProviders
    }

    open func registerHeader<View>(
        _ view: View.Type,
        viewConfiguration: @escaping (View) -> Void)
    -> Self where View: UICollectionReusableView {

        headerViewProvider = .supplementaryProvider(for: UICollectionView.elementKindSectionHeader, viewConfiguration: viewConfiguration)
        return self
    }

    open func registerFooter<View>(
        _ view: View.Type,
        viewConfiguration: @escaping (View) -> Void)
    -> Self where View: UICollectionReusableView {

        footerViewProvider = .supplementaryProvider(for: UICollectionView.elementKindSectionFooter, viewConfiguration: viewConfiguration)
        return self
    }

    public final func dequeueCell(
        in collectionView: UICollectionView,
        indexPath: IndexPath,
        with item: AnyHashable)
    -> UICollectionViewCell? {

        cellProviders[item]?.dequeue(in: collectionView, indexPath: indexPath)
    }
}
#endif
