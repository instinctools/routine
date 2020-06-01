//
//  RxDiffableDataSource.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DifferenceKit

class RxDiffableDataSource<Model: Differentiable, Element: Differentiable>: NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {
    
    typealias Section = ArraySection<Model, Element>
    typealias Item = Section.Collection.Element
    
    private(set) var sectionModels: [Section] = []
    
    private let animationConfiguration: AnimationConfiguration
    private let configureCell: (UITableView, IndexPath, Item) -> UITableViewCell
    
    init(animationConfiguration: AnimationConfiguration,
         configureCell: @escaping (UITableView, IndexPath, Item) -> UITableViewCell) {
        self.animationConfiguration = animationConfiguration
        self.configureCell = configureCell
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        return sectionModels[indexPath.section].elements[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[Section]>) {
        Binder(self) { (dataSource, newSections) in
            let oldSections = dataSource.sectionModels
            let changeset = StagedChangeset(source: oldSections, target: newSections)
            
            for difference in changeset {
                let updateBlock = {
                    dataSource.sectionModels = difference.data
                    tableView.batchUpdates(
                        difference,
                        animationConfiguration: dataSource.animationConfiguration
                    )
                }
                tableView.performBatchUpdates(updateBlock)
            }
        }
        .on(observedEvent)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(tableView, indexPath,
                             sectionModels[indexPath.section].elements[indexPath.row])
    }
}

private extension UITableView {

    func indexSet(_ values: [Int]) -> IndexSet {
        let indexSet = NSMutableIndexSet()
        for i in values {
            indexSet.add(i)
        }
        return indexSet as IndexSet
    }
    
    func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        insertRows(at: paths, with: animationStyle)
    }
    
    func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        deleteRows(at: paths, with: animationStyle)
    }
    
    func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath) {
        moveRow(at: from, to: to)
    }
    
    func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        reloadRows(at: paths, with: animationStyle)
    }
    
    func insertSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        insertSections(indexSet(sections), with: animationStyle)
    }
    
    func deleteSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        deleteSections(indexSet(sections), with: animationStyle)
    }
    
    func moveSection(_ from: Int, to: Int) {
        moveSection(from, toSection: to)
    }
    
    func reloadSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        reloadSections(indexSet(sections), with: animationStyle)
    }
    
    func batchUpdates<Section>(_ changes: Changeset<Section>,
                               animationConfiguration: AnimationConfiguration) {
        
        deleteSections(
            changes.sectionDeleted,
            animationStyle: animationConfiguration.deleteAnimation
        )
        insertSections(
            changes.sectionInserted,
            animationStyle: animationConfiguration.insertAnimation
        )

        for (from, to) in changes.sectionMoved {
            moveSection(from, to: to)
        }

        deleteItemsAtIndexPaths(
            changes.elementDeleted.map { IndexPath(item: $0.element, section: $0.section) },
            animationStyle: animationConfiguration.deleteAnimation
        )
        insertItemsAtIndexPaths(
            changes.elementInserted.map { IndexPath(item: $0.element, section: $0.section) },
            animationStyle: animationConfiguration.insertAnimation
        )
        reloadItemsAtIndexPaths(
            changes.elementUpdated.map { IndexPath(item: $0.element, section: $0.section) },
            animationStyle: animationConfiguration.reloadAnimation
        )

        for (from, to) in changes.elementMoved {
            moveItemAtIndexPath(
                IndexPath(item: from.element, section: from.section),
                to: IndexPath(item: to.element, section: to.section)
            )
        }
    }
}
