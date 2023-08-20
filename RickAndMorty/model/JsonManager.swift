import Foundation

// MARK: JsonManager - загрузка json-ов



// MARK: загрузка эпизода
func uploudJsonEpisode(_ cell: EpisodeTableViewCell, url: String, using completionHandler: @escaping (EpisodeTableViewCell, Int, Episode?, String) -> Void){
    NSLog("uploudJsonEpisode: entrance")
    NSLog("uploudJsonEpisode: url = " + url)
    
    guard let apiURL = URL(string: url) else {
        completionHandler(cell, 2, nil, "apiURL : error")
        return
    }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: apiURL) { (data, response, error) in
        guard let data = data, error == nil else {
            completionHandler(cell, 1, nil, error!.localizedDescription)
            return
        }
        print(data)
           
        let jsonStructure: Episode = try! JSONDecoder().decode(Episode.self, from: data)
        NSLog("uploudJsonEpisode: jsonStructure.name = " + jsonStructure.name)
        NSLog("uploudJsonEpisode: jsonStructure.air_date = " + jsonStructure.air_date)
        NSLog("uploudJsonEpisode: jsonStructure.episode = " + jsonStructure.episode)

        completionHandler(cell, 0, jsonStructure, "")
    }
    task.resume()
    NSLog("uploudJsonEpisode: viewAvatar: exit")
}

// MARK: загрузка origin
func uploudJsonOrigin(url: String, using completionHandler: @escaping (Int, OriginJson?, String) -> Void){
    NSLog("uploudJsonOrigin: entrance")
    NSLog("uploudJsonOrigin: url = " + url)
    
    guard let apiURL = URL(string: url) else {
        completionHandler(2, nil, "apiURL : error")
        return
    }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: apiURL) { (data, response, error) in
        guard let data = data, error == nil else {
            completionHandler(1, nil, error!.localizedDescription)
            return
        }
        print(data)
           
        let jsonStructure: OriginJson = try! JSONDecoder().decode(OriginJson.self, from: data)
        NSLog("uploudJsonOrigin: jsonStructure.name = " + jsonStructure.name)
        NSLog("uploudJsonOrigin: jsonStructure.type = " + jsonStructure.type)
        completionHandler(0, jsonStructure, "")
    }
    task.resume()
    NSLog("uploudJsonOrigin: viewAvatar: exit")
}

// MARK: загрузка Characters
func uploudJsonCharacter(using completionHandler: @escaping (Int, CharacterJson?, String) -> Void){
    NSLog("uploudJsonCharacter: entrance")
    let characterURL = "https://rickandmortyapi.com/api/character"
    
    guard let apiURL = URL(string: characterURL) else {
        fatalError("some error")
    }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: apiURL) { (data, response, error) in
        guard let data = data, error == nil else {
            completionHandler(1, nil, error!.localizedDescription)
            return
        }
        print(data)
           
        let jsonStructure: CharacterJson = try! JSONDecoder().decode(CharacterJson.self, from: data)
        NSLog("uploudJsonCharacter: jsonStructure.results[0].name = " + jsonStructure.results[0].name)
        NSLog("uploudJsonCharacter: jsonStructure.results[0].image = " + jsonStructure.results[0].image)
        completionHandler(0, jsonStructure, "")
    }
    task.resume()
    NSLog("uploudJsonCharacter: viewAvatar: exit")
}
