//
//  ViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/29/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    // MARK: - Private Properties
    
    private var viewModel = MoviesViewModel()
    private lazy var dataSource = createDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
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
        
        viewModel.requestData()
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - Compositional Layout

extension ViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "headerId", alignment: .top)
            
            if section == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1)))
                item.contentInsets.top = 16
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalWidth(0.66 * 1.28)), subitems: [item])
                
                group.interItemSpacing = .fixed(16)

                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                
//                section.boundarySupplementaryItems = [headerElement]
                
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.bottom = 16
                item.contentInsets.leading = 16
                item.contentInsets.trailing = 16
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets.top = 16
                section.contentInsets.bottom = 16
                
//                section.boundarySupplementaryItems = [headerElement]
                
                return section
            }
        }
    }
}

// MARK: - DiffableDataSource

extension ViewController {
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, Movie> {
       return UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { [weak self] (collectionView, index, movie) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch self.viewModel.sections[index.section].type {
            case .today:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: index)
                cell.backgroundColor = .red
                return cell
            case .upcoming:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: index)
                cell.backgroundColor = .blue
                return cell

            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.sections)
        
        viewModel.sections.forEach { section in
            snapshot.appendItems(section.movies, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
