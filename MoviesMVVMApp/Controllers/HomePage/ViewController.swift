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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupCollectionView()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        collectionView.register(TopRatedCell.self, forCellWithReuseIdentifier: "cellId")
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
        
        viewModel.requestData()
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController(viewModel: MovieViewModel(movie: self.viewModel.getMovie(indexPath: indexPath)))
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Compositional Layout

extension ViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            if section == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalWidth(0.66 * 1.28)), subitems: [item])
                
                group.interItemSpacing = .fixed(16)

                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                
                section.boundarySupplementaryItems = [headerElement]
                
                return section
            } else {
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
}

// MARK: - DiffableDataSource

extension ViewController {
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, Movie> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { [weak self] (collectionView, index, movie) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch self.viewModel.sections[index.section].type {
            case .today:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId1", for: index) as? TodayMovieCell else { return nil }
                cell.configure(viewModel: MovieViewModel(movie: self.viewModel.getMovie(indexPath: index)))
                return cell
            case .topRated:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: index) as? TopRatedCell else { return nil }
                cell.configure(viewModel: MovieViewModel(movie: self.viewModel.getMovie(indexPath: index)))
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = self.dataSource.snapshot()
              .sectionIdentifiers[indexPath.section]
            
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "headerId",
                for: indexPath) as? SectionHeaderView else { return nil }
            view.setTitle(section.type.rawValue)
            return view
        }
        
        return dataSource
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
