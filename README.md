# DataSourcerer

DataSourcerer provides a type-safe DSL style data source for `UICollectionView` powered by [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)

### Basic Usage

To fill in collection view with data:
1. Connect the data source to the collection view.
2. Apply a `State` with a list of `Section` or a single `Section` by using `ForEach`.

```
let dataSource = CollectionViewDataSource(collectionView: collectionView)
dataSource.state = State {
    ForEach(items) { item in 
        BaseListCell<Item> { cell, _, _ in 
            // config cell
        }
        .onSelected {
            // Cell is selected
        }
        .onDeselected {
            // Cell is deselected
        }
    }
}
```

#### Section

`Section` represents a section in the collection view's data source, consisted of a list of data models and its corresponding cell. It also has its own section header and section footer.
Additionally you are going to have to specify support for section header and section footer in your collection view's layout.

Example using `UICollectionLayoutListConfiguration`
```
var listConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
listConfig.headerMode = .supplementary
listConfig.footerMode = .supplementary

dataSource.state = State {
    Section(sectionIdentifier: .main) {
        ForEach(items) { item in 
            BaseListCell<Item> { cell, _, _ in
                // configure cell
            }
        }
    }
    .registerHeader(HeaderView.self) { headerView in 
        // configure header
    }
    .registerFooter(FooterView.self) { footerView in 
        // configure footer
    }
}
```
