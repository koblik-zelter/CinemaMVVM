//
//  FavoritesViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import SPAlert

class FavoritesViewController: UIViewController {

    typealias FavoriteSnapshot = NSDiffableDataSourceSnapshot<FavoriteSection, Movie>
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource = createDataSource()
    private var viewModel: FavoritesViewModel

    // MARK: - Init
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.fetchFavorites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupCollectionView()
        setupViewModel()
    }
    
    // MARK: - Private methods

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.register(TodayMovieCell.self, forCellWithReuseIdentifier: "cellId1")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.dataSource = createDataSource()
    }
    
    private func setupViewModel() {
        viewModel.requestCallback = { [weak self] in
            guard let self = self else { return }
            self.applySnapshot()
        }
        
        viewModel.onRemoveFromFavorites = { [weak self] in
            guard let self = self else { return }
            self.applySnapshot()
            self.showAlert(title: "The movie was deleted from favorites", presset: .done)
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: error.rawValue, presset: .done)

        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.item)" as NSString
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { actions -> UIMenu? in
            
            let delete = UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                self.viewModel.removeMovieAt(indexPath: indexPath)
            }
            return UIMenu(title: "", children: [delete])
        }
        
        return configuration
    }
}

// MARK: - Compositional Layout

extension FavoritesViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets.top = 16
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
            
            section.boundarySupplementaryItems = [headerElement]
            
            return section
        }
    }
}

// MARK: - DiffableDataSource

extension FavoritesViewController {
    private func createDataSource() -> UICollectionViewDiffableDataSource<FavoriteSection, Movie> {
        let dataSource = UICollectionViewDiffableDataSource<FavoriteSection, Movie>(collectionView: collectionView) { [weak self] (collectionView, index, movie) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId1", for: index) as? TodayMovieCell else { return nil }
            cell.configure(viewModel: MovieViewModel(movie: self.viewModel.getMovie(indexPath: index)))
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "headerId",
                for: indexPath) as? SectionHeaderView else { return nil }
            view.setTitle("Favorites")
            return view
        }
        
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = FavoriteSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.movies, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

enum FavoriteSection: Hashable {
    case main
}

