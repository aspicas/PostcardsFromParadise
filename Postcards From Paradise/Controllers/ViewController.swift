//
//  ViewController.swift
//  Postcards From Paradise
//
//  Created by David Garcia on 12/27/17.
//  Copyright © 2017 David Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var colors = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors += [.black, .blue, .green, .yellow, .white, .gray, .red, .orange, .cyan, .purple, .magenta]
        for hue in 0...9 {
            for sat in 1...10 {
                let color = UIColor(hue: CGFloat(hue)/10, saturation: CGFloat(sat)/10, brightness: 1, alpha: 1)
                self.colors.append(color)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        let color = self.colors[indexPath.row]
        cell.backgroundColor = color
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }
}

