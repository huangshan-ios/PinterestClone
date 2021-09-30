//
//  CollectionsViewController.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import UIKit
import Combine

class CollectionsViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, ImageCollectionItem>(collectionView: imagesCollectionView) { (collection, indexPath, item) -> UICollectionViewCell? in
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.className, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setupCell(with: item)
        return cell
    }
    private var diffableSnapshot = NSDiffableDataSourceSnapshot<Section, ImageCollectionItem>()
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    
    var coordinator: CollectionsCoordinator!
    var viewModel: CollectionsViewModel!
    var environment: CollectionsServiceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureCollectionViews()
        configureViewModel()
        
        // Load new collection
        viewModel.send(event: .refreshCollections)
        
    }
    
    private func configureAppearance() {
        title = "Collections"
    }
    
    private func configureCollectionViews() {
        // Set delegate
        imagesCollectionView.delegate = self
        
        // Setup collection view layout
        imagesCollectionView.collectionViewLayout = createPinterestLayout(with: dataSource)
    }
    
    private func configureViewModel() {
        viewModel.$state.sink { [weak self] state in
            guard let self = self else { return }
            self.handle(newState: state)
        }.store(in: &cancellables)
    }
    
    private func handle(newState: CollectionsViewModel.State) {
        switch newState {
        case .loadded(let items):
            updateDataSource(with: true, and: items)
        default: break
        }
    }
    
    private func updateDataSource(with animation: Bool, and items: [ImageCollectionItem]) {
        if diffableSnapshot.numberOfSections == 0 {
            diffableSnapshot.appendSections([.main])
        }
        diffableSnapshot.appendItems(items, toSection: .main)
        dataSource.apply(diffableSnapshot, animatingDifferences: animation)
    }
    
}

extension CollectionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= (dataSource.snapshot().itemIdentifiers(inSection: .main).count - 5) && !viewModel.state.isLoadding {
            currentPage += 1
            viewModel.send(event: .loadMoreCollections(currentPage))
        }
    }
}

extension CollectionsViewController {
    func createPinterestLayout(with dataSource: UICollectionViewDiffableDataSource<Section, ImageCollectionItem>) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let spacing = CGFloat(10)
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let numOfColumn = contentSize.width > 800 ? 3 : 2
            let itemWidth = (contentSize.width - (spacing * CGFloat(numOfColumn + 1))) / CGFloat(numOfColumn)
            let xOffsets: [CGFloat] = (0..<numOfColumn).map { CGFloat($0) * itemWidth }
            var yOffsets: [CGFloat] = .init(repeating: spacing, count: numOfColumn)
            var columnIndex = 0
            var contentHeight: CGFloat = 0
            
            let items = dataSource.snapshot()
                .itemIdentifiers(inSection: Section(rawValue: sectionIndex)!)
                .enumerated()
                .map { (index, itemIdentifier) -> NSCollectionLayoutGroupCustomItem in
                    let itemPhotoHeight = itemWidth * itemIdentifier.imageSize.height / itemIdentifier.imageSize.width
                    let itemHeight = itemPhotoHeight
                    let xOffset = columnIndex == 0 ? spacing : xOffsets[columnIndex] + (spacing * CGFloat(columnIndex + 1))
                    let yOffset = yOffsets[columnIndex] + (spacing * CGFloat(Int(index / numOfColumn)))
                    let frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[columnIndex] = yOffsets[columnIndex] + itemHeight
                    columnIndex = columnIndex < (numOfColumn - 1) ? (columnIndex + 1) : 0
                    return NSCollectionLayoutGroupCustomItem(frame: frame)
                }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(contentHeight))
            
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { (environment) -> [NSCollectionLayoutGroupCustomItem] in
                return items
            }
                        
            return NSCollectionLayoutSection(group: group)
        }
        return layout
    }
}
