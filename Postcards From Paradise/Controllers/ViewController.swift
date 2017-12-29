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
    
    var image: UIImage?
    
    var topText = "Bienvenido a iOS 11"
    var bottomText = "iOS 11 rules"
    
    var topFontName = "Avenir Next"
    var bottomFontName = "Avenir Next"
    
    var topFontColor = UIColor.white
    var bottomFontColor = UIColor.white
    
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
    
    func renderPostcard(){
        // 1. Definir la zona de dibujo rectangular para trabajar. 3000x2400
        
        // 2. Crear dos rectangulos para los dos textos de la postal
        
        // 3. A partir de los nombres de las fuentes, crear los objetos UIFont
        // Dejaremos una fuente por defecto (Avenir Next) por si algo falla
        
        // 4. NSMutableParagraphStyle para centrar el texto en la etiqueta
        
        // 5. Definir la estructura de la etiqueta como el color y la fuente. (attributed strings (NSAttributedStringKey))
        
        // 6. Iniciar la renderizacion de la imagen (UIGraphicsImageRenderer)
        
            // 6.1 Renderizar la zona con un fondo gris
        
            // 6.2 Pintaremos la imagen seleccionada del usuario empezando por el borde superior izquierdo.
        
            // 6.3 Pintar las dos etiquetas de texto con los parámetros configurados en 5
    }
}

