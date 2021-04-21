//
//  ViewController.swift
//  gif-me
//
//  Created by Raitis Saripo on 19/04/2021.
//

import UIKit

class GifGridViewController: UIViewController {

    @IBOutlet weak var gifCollectionView: UICollectionView!
    
    @IBOutlet weak var searchField: UITextField! {
        didSet{
            searchField.setLeftView(image: UIImage(systemName: K.clearButtonName)!)
            searchField.tintColor = .darkGray
        }
    }

    var gifManager = GifManager()
    
    //Data
    var gifs = [Gif]()
    
    //Gif query offset
    var offset = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifManager.fetchData { (viewModelData) in
            self.gifs = viewModelData
            DispatchQueue.main.async {
                self.gifCollectionView.reloadData()
            }
        }
        
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
        
        searchField.delegate = self
        
        configureCollectionViewLayout()
        configureSearchField()
    }
    
    func configureSearchField() {
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchField.returnKeyType = UIReturnKeyType.done
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = searchField.layer.bounds.height / 2
        searchField.clearButtonMode = .always
        searchField.clearButtonMode = .whileEditing
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if searchField.text?.count != 0 {
            if let searchLabel = textField.text {
                navigationItem.title = "\(searchLabel.capitalized) GIFs"
            }
            
            //Perform search
            offset = 0
            gifManager.fetchData(searchQuery: searchField.text ?? "", offset: offset) { (viewModelData) in
                self.gifs = viewModelData
                DispatchQueue.main.async {
                    self.gifCollectionView.reloadData()
                }
            }
        } else {
            navigationItem.title = "Trending GIFs"
            gifManager.fetchData() { (viewModelData) in
                self.gifs = viewModelData
                DispatchQueue.main.async {
                    self.gifCollectionView.reloadData()
                }
            }
        }
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let size = (gifCollectionView.frame.size.width - 10) / 2
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        gifCollectionView.collectionViewLayout = layout
    }
}

// MARK: - CollectionView Delegate Methods

extension GifGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - CollectionView Data Source Methods

extension GifGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellName, for: indexPath) as! GifCollectionViewCell

        cell.loadGif(with: gifs[indexPath.row])
        cell.gifImageView.layer.cornerRadius = 10

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == gifs.count - 1 && searchField.text?.count != 0 {
            offset += 20
            gifManager.fetchData(searchQuery: searchField.text ?? "", offset: offset) { (viewModelData) in
                self.gifs.append(contentsOf: viewModelData)
                if viewModelData.count == 0 {
                    return
                }
                DispatchQueue.main.async {
                    self.gifCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - CollectionView Delegate Flow Layout Methods

extension GifGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.frame.size.width / 2)  - 10
        return CGSize(width: size, height: size)
        
        //return CGSize(width: 180, height: 180)
    }
    
    
}

// MARK: - TextField Delegate Methods

extension GifGridViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}


// MARK: - UITextField Methods

extension UITextField {
    func setLeftView(image: UIImage) {
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 22, height: 20))
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        iconView.image = image
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        tintColor = .lightGray
    }
}
