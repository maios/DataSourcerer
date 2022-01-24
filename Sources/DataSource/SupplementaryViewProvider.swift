#if canImport(UIKit)
import UIKit

public struct SupplementaryProvider: CollectionViewDequeueable {
    public typealias Registration<View: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<View>

    private let viewProvider: (UICollectionView, IndexPath) -> UICollectionReusableView?

    public init<View: UICollectionReusableView>(viewRegistration: Registration<View>) {
        viewProvider = { collectionView, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: viewRegistration, for: indexPath)
        }
    }

    public func dequeue(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        viewProvider(collectionView, indexPath)
    }
}

extension SupplementaryProvider {

    public static func supplementaryProvider<View>(
        for elementKind: String,
        viewConfiguration: @escaping (View) -> Void)
    -> SupplementaryProvider where View: UICollectionReusableView {

        let registration = Registration<View>(elementKind: elementKind) { (view, _, _) in
            viewConfiguration(view)
        }
        return SupplementaryProvider(viewRegistration: registration)
    }
}

extension SupplementaryProvider {

    public enum ElementKind {
        public static let boundaryHeader = "layout-header"
        public static let boundaryFooter = "layout-footer"
    }
}
#endif
