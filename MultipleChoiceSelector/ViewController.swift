//
//  ViewController.swift
//  MultipleChoiceSelector
//
//  Created by Sarawanak on 3/27/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cv: UICollectionView!
    var priorityTypeControl: PrioritySelectionControl?

    var data: [PriorityType]?

    override func viewDidLoad() {
        super.viewDidLoad()
        data = createData()
        createSelectionControl()
        createButton()
    }

    @objc func setPriority(_ sender: UIButton) {
        let i = priorityTypeControl?.selectedItemIndex ?? 0
        priorityTypeControl?.select(itemAt: (i+1) % 3)
    }

    @objc func prioritySelected(_ sender: PrioritySelectionControl) {
        print("Seeleced index: \(String(describing: sender.selectedItemIndex))")
    }

    func createSelectionControl() {
        priorityTypeControl = PrioritySelectionControl(data: data!, columns: 3, padding: 6)
        priorityTypeControl?.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 150)

        priorityTypeControl?.addTarget(self, action: #selector(prioritySelected(_:)), for: .touchUpInside)
        self.view.addSubview(priorityTypeControl!)
    }

    func createButton() {
        let btn = UIButton(frame: CGRect(x: view.bounds.midX - 100, y: 200, width: 150, height: 44))
        btn.setTitle("Select Next", for: .normal)
        btn.addTarget(self, action: #selector(setPriority(_:)), for: .touchDown)
        btn.setTitleColor(self.view.tintColor, for: .normal)
        view.addSubview(btn)
    }

    func createData() -> [PriorityType] {
        var priorities = [PriorityType]()

        let p1 = PriorityType(priorityImageName: "facebook", priorityValue: "Facebook")
        let p2 = PriorityType(priorityImageName: "twitter", priorityValue: "Twitter")
        let p3 = PriorityType(priorityImageName: "instagram", priorityValue: "Instagram")

        priorities = [p1, p2, p3]
        return priorities
    }

}

