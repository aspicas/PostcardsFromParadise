//
//  ViewController.swift
//  Postcards From Paradise
//
//  Created by David Garcia on 12/27/17.
//  Copyright © 2017 David Garcia. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,
                    UICollectionViewDataSource,
                    UICollectionViewDelegate,
                    UICollectionViewDragDelegate,
                    UIDropInteractionDelegate{
    
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
        
        self.colorCollectionView.dragDelegate = self
        
        self.postcardImageView.isUserInteractionEnabled = true
        let dropInteraction = UIDropInteraction(delegate: self)
        self.postcardImageView.addInteraction(dropInteraction)
        
        renderPostcard()
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
        let drawRect = CGRect(x: 0, y: 0, width:  3000, height: 2400)
        
        // 2. Crear dos rectangulos para los dos textos de la postal
        let topRect = CGRect(x: 300, y: 200, width: 2400, height: 800)
        let bottomRect = CGRect(x: 300, y: 1800, width: 2400, height: 600)
        
        // 3. A partir de los nombres de las fuentes, crear los objetos UIFont
        // Dejaremos una fuente por defecto (La de sistema) por si algo falla
        let topFont = UIFont(name: self.topFontName, size: 250) ?? UIFont.systemFont(ofSize: 240)
        let bottomFont = UIFont(name: self.bottomFontName, size: 120) ?? UIFont.systemFont(ofSize: 80)
        
        // 4. NSMutableParagraphStyle para centrar el texto en la etiqueta
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        // 5. Definir la estructura de la etiqueta como el color y la fuente. (attributed strings (NSAttributedStringKey))
        let topAttributes : [NSAttributedStringKey: Any] =
            [
                .foregroundColor : topFontColor,
                .font : topFont,
                .paragraphStyle : centered
            ]
        
        let bottomAttributes : [NSAttributedStringKey: Any] =
            [
                .foregroundColor : bottomFontColor,
                .font : bottomFont,
                .paragraphStyle : centered
            ]
        
        // 6. Iniciar la renderizacion de la imagen (UIGraphicsImageRenderer)
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        self.postcardImageView.image = renderer.image(actions:
            { (context) in
                // 6.1 Renderizar la zona con un fondo gris
                UIColor.lightGray.set()
                context.fill(drawRect)
                
                // 6.2 Pintaremos la imagen seleccionada del usuario empezando por el borde superior izquierdo.
                self.image?.draw(at: CGPoint(x: 0, y: 0))
                
                // 6.3 Pintar las dos etiquetas de texto con los parámetros configurados en 5
                self.topText.draw(in: topRect, withAttributes: topAttributes)
                self.bottomText.draw(in: bottomRect, withAttributes: bottomAttributes)
            })
    }
    
    // MARK: UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = self.colors[indexPath.row]
        let itemProvider = NSItemProvider(object: color)
        let item = UIDragItem(itemProvider: itemProvider)
        return [item]
    }
    
    // MARK: UIDropIntegrationDelegate
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let dropLocation = session.location(in: self.postcardImageView)
        
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            //Se ejecutara si lo que hemos soltado es un String
            session.loadObjects(ofClass: NSString.self, completion:
                { (items) in
                    guard let fontName = items.first as? String else { return }
                    if dropLocation.y < self.postcardImageView.bounds.midY {
                        self.topFontName = fontName
                    } else {
                        self.bottomFontName = fontName
                    }
                    self.renderPostcard()
            })
        } else if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) {
            //Se ejecutara si lo que hemos soltado es una imagen
            session.loadObjects(ofClass: UIImage.self, completion:
                { (items) in
                    guard let image = items.first as? UIImage else { return }
                    self.image = image
                    self.renderPostcard()
            })
        } else {
            //Se ejecutara si lo que hemos soltado es un color
            session.loadObjects(ofClass: UIColor.self , completion:
                { (items) in
                    guard let color = items.first as? UIColor else { return }
                    
                    if dropLocation.y < self.postcardImageView.bounds.midY {
                        self.topFontColor = color
                    } else {
                        self.bottomFontColor = color
                    }
                    
                    self.renderPostcard()
            })
        }
    }

    //MARK: Gesture Recognize
    @IBAction func changeText(_ sender: UITapGestureRecognizer) {
        //1. Encontrar la localizacion del tap dentro de la postal
        let tapLocation = sender.location(in:  self.postcardImageView)
        
        //2. Decidir si el usuario tiene que cambiar la etiqueta superior o inferior
        let changeTop = tapLocation.y < self.postcardImageView.bounds.midY ? true : false
        
        //3. Crear un objeto UIAlertController con un textField adicional para que el usuario escriba el texto.
        let alert = UIAlertController(title: "Cambiar Texto", message: "Escribe el nuevo texto", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "¿Qué quieres poner aquí?"
            if changeTop {
                textField.text = self.topText
            } else {
                textField.text = self.bottomText
            }
        }
        
        //4. Añadir accion 'Cambiar Texto' que cambie el texto pertinentemente y llame al metodo renderPostcard()
        let changeAction = UIAlertAction(title: "Cambiar Texto", style: .default) { (_) in
            guard let newtext = alert.textFields?[0].text else { return }
            
            if  changeTop {
                self.topText = newtext
            } else {
                self.bottomText = newtext
            }
            
            self.renderPostcard()
        }
        
        //5. Añadir una opcion 'Cancelar' que pare el proceso.
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        //6. Mostrar la alert controller
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
