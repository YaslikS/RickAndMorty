import UIKit

private let reuseIdentifier = "CharacterCell"

class GridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var listCharacters: [Character] = []
    let TAG = "GridCollectionVC: "
    var item = Int()
    let activityView = UIActivityIndicatorView()
    let fadeView:UIView = UIView()

    override func viewDidLoad() {
        NSLog(TAG + "viewDidLoad: entrance")
        super.viewDidLoad()
        
        settingsViews()
        uploudJsonCharacter(using: uploadCompletionHandler)
        
        NSLog(TAG + "viewDidLoad: exit")
    }
    
    // MARK: результат загрузки
    lazy var uploadCompletionHandler: (Int, CharacterJson?, String) -> Void = { doneWorking, jsonStructure, desc in
        NSLog(self.TAG + "uploadCompletionHandler: entrance")
        switch doneWorking {
        case 0: //  удачная загрузка
            NSLog(self.TAG + "uploadCompletionHandler: doneWorking = " + String(doneWorking))
            self.listCharacters = jsonStructure!.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.fadeView.removeFromSuperview()
                self.activityView.stopAnimating()
            }
        case 1: //  НЕудачная загрузка
            NSLog(self.TAG + "uploadCompletionHandler: doneWorking = " + String(doneWorking))
            let alert = UIAlertController(title: "Error: " + desc, message: nil, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] (_) in
                NSLog(self!.TAG + "uploadCompletionHandler: UIAlertController: OK")
            }
            alert.addAction(okAction)
            //  для ipad'ов
            if let popover = alert.popoverPresentationController{
                NSLog(self.TAG + "clickClearButton: popoverPresentationController: for ipad's")
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            DispatchQueue.main.async {
                self.fadeView.removeFromSuperview()
                self.activityView.stopAnimating()
                self.present(alert, animated: true, completion: nil)
            }
        default:    //  НЕудачная загрузка
            NSLog(self.TAG + "uploadCompletionHandler: doneWorking = " + String(doneWorking))
            DispatchQueue.main.async {
                self.fadeView.removeFromSuperview()
                self.activityView.stopAnimating()
            }
        }
    
        NSLog(self.TAG + "uploadCompletionHandler: exit")
    }
    
    // MARK: одна ячейка
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCollectionViewCell
        cell.layer.cornerRadius = 10
        
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.contentMode = .scaleToFill
        viewPic(picURL: listCharacters[indexPath.item].image, iv: cell.imageView)
        
        cell.Label.textColor = UIColor.white
        cell.Label.text = listCharacters[indexPath.item].name
        cell.Label.sizeToFit()
        cell.Label.numberOfLines = 3
        
        return cell
    }
    
    // MARK: загрузка картинки
    func viewPic(picURL: String, iv: UIImageView){
        guard let apiURL = URL(string: picURL) else {
            fatalError("some error")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async { iv.image = UIImage(data: data) }
        }
        task.resume()
    }
    
    // MARK: количество ячеек
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog(TAG + "numberOfItemsInSection: listCharacters.count " + String(listCharacters.count))
        return listCharacters.count
    }

    // MARK: нажатие на ячейку
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        item = indexPath.item
        NSLog(TAG + "didSelectItemAt: indexPath.item " + String(indexPath.item))
        NSLog(TAG + "didSelectItemAt: listCharacters[indexPath.item].name " + listCharacters[indexPath.item].name)
        
        self.performSegue(withIdentifier: "toDetailsVC", sender: self)
    }
    
    // MARK: перед началом перехода
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("MainViewCon: prepare: entrance")
        if(segue.identifier == "toDetailsVC"){
            NSLog("MainViewCon: prepare: segue.identifier == toDetailsVC")
            let detailsTableViewController = segue.destination as? DetailsTableViewController

            detailsTableViewController!.name = listCharacters[item].name
            detailsTableViewController!.gender = listCharacters[item].gender
            detailsTableViewController!.species = listCharacters[item].species
            detailsTableViewController!.status = listCharacters[item].status
            detailsTableViewController!.type = listCharacters[item].type
            detailsTableViewController!.picURL = listCharacters[item].image
            detailsTableViewController!.originURL = listCharacters[item].origin.url
            detailsTableViewController!.episodes = listCharacters[item].episode
        }
    }
       
    // MARK: рас-ние между секциями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    // MARK: рас-ние между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // MARK: размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width-60)/2, height: 220.0)
    }
    
    // MARK: настройка view
    func settingsViews(){
        NSLog(TAG + "settingsViews: entrance")
        collectionView!.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.4

        self.view.addSubview(fadeView)

        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
        NSLog(TAG + "settingsViews: exit")
    }
    
}
