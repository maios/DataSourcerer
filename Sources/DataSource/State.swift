#if canImport(UIKit)
import UIKit

public struct ForEach {
    internal let items: [AnyHashable]
    internal let cellProviders: [AnyHashable: CellProvider]

    public init<Item, Cell>(
        items: [Item],
        cellTransform: @escaping (Item) -> CollectionViewCell<Cell, Item>)
    where Item: Hashable, Cell: UICollectionViewCell {

        self.items = items
        self.cellProviders = items.reduce(into: [:]) { result, item in
            result[item] = CellProvider(item: item, cell: cellTransform(item))
        }
    }

    @resultBuilder
    public struct Builder {

        public static func buildBlock(_ forEach: ForEach) -> ForEach {
            return forEach
        }
    }
}

extension CollectionViewDataSource {

    public struct State {
        internal let sections: [Section]

        internal init(sections: [Section]) {
            self.sections = sections
        }

        public init(@Builder _ state: () -> State) {
            self = state()
        }

        @resultBuilder
        public struct Builder {

            public static func buildBlock(_ sections: [Section]) -> State {
                State(sections: sections)
            }

            public static func buildBlock(_ forEach: ForEach) -> State {
                struct SingleSection: Hashable {}
                let section = Section(sectionIdentifier: SingleSection()) { forEach }
                return State(sections: [section])
            }
        }
    }
}
#endif
