//
//  PrioritySelectionController.swift
//  CollectorTester
//
//  Created by Sarawanak on 3/22/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

struct PriorityType {

    var priorityImage: UIImage? {
        return UIImage(named: priorityImageName)
    }
    
    var priorityValue: String
    private var priorityImageName: String

    init(priorityImageName: String, priorityValue: String) {
        self.priorityImageName = priorityImageName
        self.priorityValue = priorityValue
    }
}

protocol PriorityCellViewConstraintDelegate: UICollectionViewMatchWidthLayoutProtocol { }

extension PriorityCellViewConstraintDelegate {
    var highlightImageHeightConstant: CGFloat {
        return 25
    }

    var priorityImageHeightConstant: CGFloat {
        return 34
    }

    var priorityLabelHeightConstant: CGFloat {
        let label = UILabel()
        label.text = " "
        label.sizeToFit()
        return label.bounds.height * 2
    }

    var priorityCellStackSpacing: CGFloat {
        return 10
    }

    var cellHeight: CGFloat {
        return highlightImageHeightConstant
            + priorityImageHeightConstant
            + priorityLabelHeightConstant
            + priorityCellStackSpacing * 2
    }
}

class PrioritySelectionControl: UIControl {
    private var collectionView: UICollectionView!
    private var data: [PriorityType]?

    var previousIndexPath = IndexPath(item: 0, section: 0)

    private(set) var selectedItemIndex: Int? {
        didSet{
            sendActions(for: .touchUpInside)
            let indexPath = IndexPath(item: selectedItemIndex!, section: 0)
            synchronizeState(indexPath)
        }
    }

    convenience init(data: [PriorityType], columns: Int, padding: CGFloat) {
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 150)
        self.init(frame: frame)
        self.data = data

        let layout = UICollectionViewMatchWidthLayout(columns: columns, cellPadding: padding)
        layout.delegate = self

        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(PriorityTypeCollectionViewCell.self, forCellWithReuseIdentifier: "priorityCell")
    }

    override func draw(_ rect: CGRect) {
        addSubview(collectionView)
        if selectedItemIndex == nil {
            selectedItemIndex = 0
        }
    }

    func select(itemAt index: Int) {
        let indexPath = IndexPath(item: index, section: 0)

        guard let cell = collectionView.cellForItem(at: indexPath),
        let priorityCell = cell as? PriorityTypeCollectionViewCell else { return }

        selected(cell: priorityCell)
    }
}

extension PrioritySelectionControl: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priorityCell", for: indexPath) as! PriorityTypeCollectionViewCell
        cell.delegate = self
        cell.createSubviews(data![indexPath.item].priorityImage, data![indexPath.item].priorityValue)
        cell.isChosen = selectedItemIndex == indexPath.item
        return cell
    }
}

extension PrioritySelectionControl: PriorityTypeCollectionViewCellDelegate {

    func selected(cell: PriorityTypeCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
            !cell.isChosen else {
            return
        }

        selectedItemIndex = indexPath.item
    }

    func synchronizeState(_ currentIndexPath: IndexPath) {
        guard let previousCell = collectionView.cellForItem(at: previousIndexPath) as? PriorityTypeCollectionViewCell,
            let currentCell = collectionView.cellForItem(at: currentIndexPath) as? PriorityTypeCollectionViewCell else { return }

        previousCell.isChosen = false
        currentCell.isChosen = true

        self.previousIndexPath = currentIndexPath
    }
}
