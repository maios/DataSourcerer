#if canImport(UIKit)
import UIKit

extension UICollectionViewCompositionalLayout {

    public func addBoundaryHeader(ofSize size: NSCollectionLayoutSize) {

        updateConfiguration { configuration in
            let item = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: size,
                elementKind: SupplementaryProvider.ElementKind.boundaryHeader,
                alignment: .top)
            configuration.boundarySupplementaryItems.append(item)
        }
    }

    public func addBoundaryFooter(ofSize size: NSCollectionLayoutSize) {

        updateConfiguration { configuration in
            let item = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: size,
                elementKind: SupplementaryProvider.ElementKind.boundaryFooter,
                alignment: .bottom)
            configuration.boundarySupplementaryItems.append(item)
        }
    }

    private func updateConfiguration(_ updateBlock: (UICollectionViewCompositionalLayoutConfiguration) -> Void) {
        let configuration = self.configuration
        updateBlock(configuration)

        self.configuration = configuration
    }
}
#endif
