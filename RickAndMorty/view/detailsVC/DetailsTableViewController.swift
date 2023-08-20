import UIKit

private let tableIdentifier = "EpisodeCell"

class DetailsTableViewController: UITableViewController {
    
    let TAG = "DetailsTableVC: "
    var name = String()
    var status = String()
    var species = String()
    var type = String()
    var gender = String()
    var picURL = String()
    var originURL = String()
    var episodes = [String]()
    let namePlanetLabel = UILabel()
    let typePlanetLabel = UILabel()
    let activityView = UIActivityIndicatorView()
    let containerForActivityView :UIView = UIView()
    
    override func viewDidLoad() {
        NSLog(TAG + "viewDidLoad: entrance")
        super.viewDidLoad()
        
        settingsViews()
        uploudJsonOrigin(url: originURL, using: uploadOriginCompletionHandler)
        
        NSLog(TAG + "viewDidLoad: exit")
    }
    
    // MARK: результат загрузки origin
    lazy var uploadOriginCompletionHandler: (Int, OriginJson?, String) -> Void = { doneWorking, jsonStructure, desc in
        NSLog(self.TAG + "uploadOriginCompletionHandler: entrance")
        switch doneWorking {
        case 0: //  удачная загрузка
            NSLog(self.TAG + "uploadOriginCompletionHandler: doneWorking = " + String(doneWorking))
            DispatchQueue.main.async {
                self.namePlanetLabel.text = jsonStructure?.name
                self.typePlanetLabel.text = jsonStructure?.type
                self.containerForActivityView.removeFromSuperview()
                self.activityView.stopAnimating()
            }
        case 1: //  НЕудачная загрузка
            NSLog(self.TAG + "uploadOriginCompletionHandler: doneWorking = " + String(doneWorking))
            let alert = UIAlertController(title: "Error: " + desc, message: nil, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] (_) in
                NSLog(self!.TAG + "uploadOriginCompletionHandler: UIAlertController: OK")
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
                self.containerForActivityView.removeFromSuperview()
                self.activityView.stopAnimating()
                self.present(alert, animated: true, completion: nil)
            }
        case 2: //  origin = unknown
            NSLog(self.TAG + "uploadOriginCompletionHandler: doneWorking = " + String(doneWorking))
            DispatchQueue.main.async {
                self.namePlanetLabel.text = "None"
                self.typePlanetLabel.text = "None"
                self.containerForActivityView.removeFromSuperview()
                self.activityView.stopAnimating()
            }
        default:    //  НЕудачная загрузка
            NSLog(self.TAG + "uploadOriginCompletionHandler: doneWorking = " + String(doneWorking))
        }
    
        NSLog(self.TAG + "uploadOriginCompletionHandler: exit")
    }
    
    // MARK: одна ячейка
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! EpisodeTableViewCell
        
        cell.secondView.layer.cornerRadius = 10
        cell.nameLabel.text = "Loading..."
        cell.activityIndicator.isHidden = false
        uploudJsonEpisode(cell, url: episodes[indexPath.row], using: uploadEpisodeCompletionHandler)
        
        return cell
    }
    
    // MARK: результат загрузки эпизода
    lazy var uploadEpisodeCompletionHandler: (EpisodeTableViewCell, Int, Episode?, String) -> Void = { cell, doneWorking, jsonStructure, desc in
        NSLog(self.TAG + "uploadEpisodeCompletionHandler: entrance")
        switch doneWorking {
        case 0: //  удачная загрузка
            NSLog(self.TAG + "uploadEpisodeCompletionHandler: doneWorking = " + String(doneWorking))
            DispatchQueue.main.async {
                cell.nameLabel.text = jsonStructure?.name
                cell.dateLabel.text = jsonStructure?.air_date
                cell.numberLabel.text = jsonStructure?.episode
                cell.activityIndicator.isHidden = true
            }
        case 1: //  НЕудачная загрузка
            NSLog(self.TAG + "uploadEpisodeCompletionHandler: doneWorking = " + String(doneWorking))
            let alert = UIAlertController(title: "Error: " + desc, message: nil, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] (_) in
                NSLog(self!.TAG + "uploadEpisodeCompletionHandler: UIAlertController: OK")
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
                cell.nameLabel.text = ""
                cell.dateLabel.text = ""
                cell.numberLabel.text = ""
                cell.activityIndicator.isHidden = true
                self.present(alert, animated: true, completion: nil)
            }
        case 2: //  origin unknown
            NSLog(self.TAG + "uploadEpisodeCompletionHandler: doneWorking = " + String(doneWorking))
            DispatchQueue.main.async {
                cell.nameLabel.text = "error"
                cell.dateLabel.text = ""
                cell.numberLabel.text = ""
                cell.activityIndicator.isHidden = true
            }
        default:    //  НЕудачная загрузка
            NSLog(self.TAG + "uploadEpisodeCompletionHandler: doneWorking = " + String(doneWorking))
        }
        NSLog(self.TAG + "uploadEpisodeCompletionHandler: exit")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog(TAG + "numberOfItemsInSection: episodes.count " + String(episodes.count))
        return episodes.count
    }
    
    // MARK: настройка view
    func settingsViews(){
        NSLog(TAG + "settingsViews: entrance")
        containerForActivityView.frame = self.view.frame
        containerForActivityView.backgroundColor = UIColor.white
        containerForActivityView.alpha = 0.4

        self.view.addSubview(containerForActivityView)

        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
        
        tableView.rowHeight = 100
        createHeader()
        NSLog(TAG + "settingsViews: exit")
    }
    
    // MARK: создание заголовка
    func createHeader(){
        NSLog(TAG + "createHeader: entrance")
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 640))
        header.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.tableHeaderView = header
        
        let topView = createTopView(header: header)
        let infoView = createInfoView(topView: topView, header: header)
        createOriginView(infoView: infoView, header: header)
        NSLog(TAG + "createHeader: exit")
    }
    
    // MARK: создание origin
    func createOriginView(infoView: UIView, header: UIView) {
        NSLog(TAG + "createOriginView: entrance")
        let originView = UIView()
        header.addSubview(originView)
        originView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10).isActive = true
        originView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20).isActive = true
        originView.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20).isActive = true
        originView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        originView.translatesAutoresizingMaskIntoConstraints = false
        
        let originLabel = UILabel()
        originLabel.text = "Origin"
        originLabel.textColor = .white
        originLabel.font = originLabel.font.withSize(18)
        originView.addSubview(originLabel)
        originLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        originLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        originLabel.leftAnchor.constraint(equalTo: originLabel.leftAnchor, constant: 0).isActive = true
        originLabel.topAnchor.constraint(equalTo: originView.topAnchor, constant: 0).isActive = true
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let boxOriginView = UIView()
        boxOriginView.backgroundColor = UIColor(named: "BackgroundSecondColor")
        originView.addSubview(boxOriginView)
        boxOriginView.layer.cornerRadius = 10
        boxOriginView.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10).isActive = true
        boxOriginView.leftAnchor.constraint(equalTo: originView.leftAnchor, constant: 0).isActive = true
        boxOriginView.rightAnchor.constraint(equalTo: originView.rightAnchor, constant: 0).isActive = true
        boxOriginView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        boxOriginView.translatesAutoresizingMaskIntoConstraints = false
        
        let episodesLabel = UILabel()
        episodesLabel.text = "Episodes"
        episodesLabel.textColor = .white
        episodesLabel.font = episodesLabel.font.withSize(18)
        boxOriginView.addSubview(episodesLabel)
        episodesLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        episodesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        boxOriginView.leftAnchor.constraint(equalTo: originView.leftAnchor, constant: 0).isActive = true
        episodesLabel.topAnchor.constraint(equalTo: boxOriginView.bottomAnchor, constant: 12).isActive = true
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // insides in box
        let picPlanetIV = UIImageView()
        picPlanetIV.image = UIImage(named: "RaM_planetIcon")
        boxOriginView.addSubview(picPlanetIV)
        picPlanetIV.layer.cornerRadius = 10
        picPlanetIV.widthAnchor.constraint(equalToConstant: 70).isActive = true
        picPlanetIV.heightAnchor.constraint(equalToConstant: 70).isActive = true
        picPlanetIV.leftAnchor.constraint(equalTo: boxOriginView.leftAnchor, constant: 10).isActive = true
        picPlanetIV.centerYAnchor.constraint(equalTo: boxOriginView.centerYAnchor).isActive = true
        picPlanetIV.translatesAutoresizingMaskIntoConstraints = false
        
        namePlanetLabel.text = "namePlanet"
        namePlanetLabel.textColor = .white
        namePlanetLabel.font = namePlanetLabel.font.withSize(16)
        boxOriginView.addSubview(namePlanetLabel)
        namePlanetLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        namePlanetLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        namePlanetLabel.leftAnchor.constraint(equalTo: picPlanetIV.rightAnchor, constant: 20).isActive = true
        namePlanetLabel.topAnchor.constraint(equalTo: picPlanetIV.topAnchor, constant: 7).isActive = true
        namePlanetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        typePlanetLabel.text = "typePlanet"
        typePlanetLabel.textColor = .green
        typePlanetLabel.font = typePlanetLabel.font.withSize(12)
        boxOriginView.addSubview(typePlanetLabel)
        typePlanetLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        typePlanetLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        typePlanetLabel.leftAnchor.constraint(equalTo: picPlanetIV.rightAnchor, constant: 20).isActive = true
        typePlanetLabel.topAnchor.constraint(equalTo: namePlanetLabel.bottomAnchor, constant: 3).isActive = true
        typePlanetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLog(TAG + "createOriginView: exit")
    }
    
    // MARK: создание информации
    func createInfoView(topView: UIView, header: UIView) -> UIView {
        NSLog(TAG + "createInfoView: entrance")
        let infoView = UIView()
        header.addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10).isActive = true
        infoView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20).isActive = true
        infoView.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        let infoLabel = UILabel()
        infoLabel.text = "Info"
        infoLabel.textColor = .white
        infoLabel.font = infoLabel.font.withSize(18)
        infoView.addSubview(infoLabel)
        infoLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -10).isActive = true
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let boxInfoView = UIView()
        boxInfoView.backgroundColor = UIColor(named: "BackgroundSecondColor")
        infoView.addSubview(boxInfoView)
        boxInfoView.layer.cornerRadius = 10
        boxInfoView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 5).isActive = true
        boxInfoView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        boxInfoView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 0).isActive = true
        boxInfoView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        boxInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // labels
        let speciesLabel = UILabel()
        speciesLabel.text = "Species:"
        speciesLabel.textColor = .gray
        speciesLabel.font = speciesLabel.font.withSize(16)
        boxInfoView.addSubview(speciesLabel)
        speciesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        speciesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        speciesLabel.leftAnchor.constraint(equalTo: boxInfoView.leftAnchor, constant: 20).isActive = true
        speciesLabel.topAnchor.constraint(equalTo: boxInfoView.topAnchor, constant: 10).isActive = true
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let speciesValueLabel = UILabel()
        speciesValueLabel.text = species
        speciesValueLabel.textColor = .white
        speciesValueLabel.font = speciesValueLabel.font.withSize(16)
        boxInfoView.addSubview(speciesValueLabel)
        speciesValueLabel.textAlignment = .right
        speciesValueLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        speciesValueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        speciesValueLabel.rightAnchor.constraint(equalTo: boxInfoView.rightAnchor, constant: -20).isActive = true
        speciesValueLabel.topAnchor.constraint(equalTo: boxInfoView.topAnchor, constant: 10).isActive = true
        speciesValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let typeLabel = UILabel()
        typeLabel.text = "Type:"
        typeLabel.textColor = .gray
        typeLabel.font = typeLabel.font.withSize(16)
        boxInfoView.addSubview(typeLabel)
        typeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: boxInfoView.leftAnchor, constant: 20).isActive = true
        typeLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 10).isActive = true
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let typeValueLabel = UILabel()
        if type.isEmpty { typeValueLabel.text = "None"
        } else { typeValueLabel.text = type  }
        typeValueLabel.textColor = .white
        typeValueLabel.textAlignment = .right
        typeValueLabel.font = typeValueLabel.font.withSize(16)
        boxInfoView.addSubview(typeValueLabel)
        typeValueLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        typeValueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        typeValueLabel.rightAnchor.constraint(equalTo: boxInfoView.rightAnchor, constant: -20).isActive = true
        typeValueLabel.topAnchor.constraint(equalTo: speciesValueLabel.bottomAnchor, constant: 10).isActive = true
        typeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let genderLabel = UILabel()
        genderLabel.text = "Gender:"
        genderLabel.textColor = .gray
        genderLabel.font = genderLabel.font.withSize(16)
        boxInfoView.addSubview(genderLabel)
        genderLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        genderLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        genderLabel.leftAnchor.constraint(equalTo: boxInfoView.leftAnchor, constant: 20).isActive = true
        genderLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10).isActive = true
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let genderValueLabel = UILabel()
        genderValueLabel.text = gender
        genderValueLabel.textColor = .white
        genderValueLabel.textAlignment = .right
        genderValueLabel.font = genderValueLabel.font.withSize(16)
        boxInfoView.addSubview(genderValueLabel)
        genderValueLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        genderValueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        genderValueLabel.rightAnchor.constraint(equalTo: boxInfoView.rightAnchor, constant: -20).isActive = true
        genderValueLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10).isActive = true
        genderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLog(TAG + "createInfoView: exit")
        return infoView
    }
    
    // MARK: создание шапки
    func createTopView(header: UIView) -> UIView {
        NSLog(TAG + "createTopView: entrance")
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 270))
        header.addSubview(topView)
        topView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        topView.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: header.topAnchor, constant: 20).isActive = true
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        let picIV = UIImageView()
        topView.addSubview(picIV)
        picIV.backgroundColor = UIColor(named: "BackgroundSecondColor")
        picIV.clipsToBounds = true
        picIV.layer.cornerRadius = 10
        viewPic(picURL: picURL, iv: picIV)
        picIV.contentMode = .scaleToFill
        picIV.widthAnchor.constraint(equalToConstant: 150).isActive = true
        picIV.heightAnchor.constraint(equalToConstant: 150).isActive = true
        picIV.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        picIV.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        picIV.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        topView.addSubview(nameLabel)
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: picIV.bottomAnchor, constant: -10).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let aliveLabel = UILabel()
        aliveLabel.text = status
        aliveLabel.textAlignment = .center
        aliveLabel.textColor = .green
        aliveLabel.font = aliveLabel.font.withSize(12)
        topView.addSubview(aliveLabel)
        aliveLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aliveLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        aliveLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        aliveLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -45).isActive = true
        aliveLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLog(TAG + "createTopView: exit")
        return topView
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
    

}
