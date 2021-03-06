//
//  SpotifyLoginModel.swift
//  SoTube
//
//  Created by VDAB Cursist on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

class SpotifyModel {
    
    private var auth = SPTAuth.defaultInstance()!
    private var session: SPTSession!
    private var loginUrl: URL?
    
    enum StringType {
        case playString, hrefString
    }
    
    enum ItemType {
        case albums, tracks, artists
    }
    
    enum SearchItemType {
        case album, track, artist, playlist
    }
    
    
    //MARK: - Login Functions
    
    
    func setUpLogin() {
//        print("START SETUP")
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyModel.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
    }
    
    func spotifyLogin() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(loginUrl!, options: [:], completionHandler: { succes in
                if succes, self.auth.canHandle(self.auth.redirectURL) {
                    //Error handling
                }
            })
        } else {
            if UIApplication.shared.openURL(loginUrl!) {
                if auth.canHandle(auth.redirectURL) {
                    //Error handling
                }
            }
        }
    }
    
    @objc func updateAfterFirstLogin () {
//        print("UPDATE AFTER FIRST LOGIN")
        let userDefaults = UserDefaults.standard
        self.session = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "SpotifySession") as! Data) as? SPTSession
//        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session!)
//        userDefaults.set(sessionData, forKey: "SpotifySession")
//        print("ACCESTOKEN COMING")
//        print(session?.accessToken ?? "NO ACCESTOKEN")
    }
    
    private func setup () {
        auth.redirectURL     = URL(string: "SoTube://returnAfterLogin")
        auth.clientID        = "5f2b808c91b346ae89a4121ce2eff89f"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    
    //MARK: - Music Retrieval Fuctions
    
    func getCoverUrl(forArtistID artistID: String, onCompletion completionHandler: @escaping (String)->()) {
        let urlRequest = getURLRequest(forUrl: getSpotifyString(ofType: .hrefString, forItemType: .artists, andID: artistID))
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            var coverUrl = ""
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                let coverUrls = feed.value(forKeyPath: "images.url") as! [String]
                coverUrl = coverUrls.first!
            }
            completionHandler(coverUrl)
            }.resume()
    }


    func getNewReleases(amount: Int, withOffset offset: Int, onCompletion completionHandler: @escaping ([Album])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/browse/new-releases?offset=\(offset)&limit=\(amount)")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                let albums = feed.value(forKeyPath: "albums.items") as! NSArray
                var albumArray = [Album]()
                for album in albums {
                    let dictionary = album as! NSDictionary
                    let name =  dictionary.value(forKeyPath: "name") as! String
                    let artists = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let coverUrls = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let album = Album(named: name, fromArtist: artists.first!, withCoverUrl: coverUrls.first!, withId: id)
                    albumArray.append(album)
                }
                completionHandler(albumArray)
            }
        }.resume()
    }
    
    func getCategories(amount: Int, withOffset offset: Int, onCompletion completionHandler: @escaping ([Category])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/browse/categories?offset=\(offset)&limit=\(amount)")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                let categories = feed.value(forKeyPath: "categories.items") as! NSArray
                
                var categoryArray = [Category]()
                for category in categories {
                    let dictionary = category as! NSDictionary
                    let name =  dictionary.value(forKeyPath: "name") as! String
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let coverUrls = dictionary.value(forKeyPath: "icons.url") as! [String]
                    let url = dictionary.value(forKeyPath: "href") as! String
                    let category = Category(named: name,withId: id, withCoverUrl: coverUrls.first!, withUrl: url)
                    categoryArray.append(category)
                }
                completionHandler(categoryArray)
            }
        }.resume()
    }
    
    func getFeaturedPlaylists(amount: Int, withOffset offset: Int, onCompletion completionHandler: @escaping ([Playlist])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/browse/featured-playlists?offset=\(offset)&limit=\(amount)")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                
                let playlists = feed.value(forKeyPath: "playlists.items") as! NSArray
                var playlistArray = [Playlist]()
                for playlist in playlists {
                    let dictionary = playlist as! NSDictionary
                    let name =  dictionary.value(forKeyPath: "name") as! String
                    let coverUrls = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let owner = dictionary.value(forKeyPath: "owner.id") as! String
                    let playlist = Playlist(named: name, withCoverUrl: coverUrls.first!, withId: id, fromOwner: owner)
                    playlistArray.append(playlist)
                }
                completionHandler(playlistArray)
            }
        }.resume()
    }
    
    func getTracks(from album: Album, onCompletion completionHandler: @escaping ([Track])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/albums/\(album.id)/tracks")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                
                let tracks = feed.value(forKeyPath: "items") as! NSArray
                var trackArray = [Track]()
                for track in tracks {
                    let dictionary = track as! NSDictionary
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let trackNumber = dictionary.value(forKeyPath: "track_number") as! Int
                    let discNumber = dictionary.value(forKeyPath: "disc_number") as! Int
                    let duration = dictionary.value(forKeyPath: "duration_ms") as! Int
                    let coverUrl = album.coverUrl
                    let artistName = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let artistId = dictionary.value(forKeyPath: "artists.id") as! [String]
                    let albumName = album.name
                    let albumId = album.id
                    let track = Track(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl, artistName: artistName.first!, artistId: artistId.first!, albumName: albumName, albumId: albumId)
                    trackArray.append(track)
                }
                completionHandler(trackArray)
            }
        }.resume()
    }
    
    func getTracks(from playlist: Playlist, onCompletion completionHandler: @escaping ([Track])->()) {
//        let userId = "spotify"
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/users/\(playlist.owner)/playlists/\(playlist.id)/tracks")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                
                let tracks = feed.value(forKeyPath: "items.track") as! NSArray
                var trackArray = [Track]()
                for track in tracks {
                    let dictionary = track as! NSDictionary
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let trackNumber = dictionary.value(forKeyPath: "track_number") as! Int
                    let discNumber = dictionary.value(forKeyPath: "disc_number") as! Int
                    let duration = dictionary.value(forKeyPath: "duration_ms") as! Int
                    let coverUrl = dictionary.value(forKeyPath: "album.images.url") as! [String]
                    let artistName = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let artistId = dictionary.value(forKeyPath: "artists.id") as! [String]
                    let albumName = dictionary.value(forKeyPath: "album.name") as! String
                    let albumId = dictionary.value(forKeyPath: "album.id") as! String
//                    print("id: \(id), name: \(name), trackNumber: \(trackNumber), discNumber: \(discNumber), duration: \(duration), coverUrl: \(coverUrl), artistName: \(artistName), artistId: \(artistId), albumName: \(albumName), albumId: \(albumId)")
                    let track = Track(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl.first ?? "", artistName: artistName.first!, artistId: artistId.first!, albumName: albumName, albumId: albumId)
                    trackArray.append(track)
                }
                completionHandler(trackArray)
            }
            }.resume()
    }
    
    func getTracks(from artist: Artist, onCompletion completionHandler: @escaping ([Track])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/artists/\(artist.artistId)/top-tracks?country=BE")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                
                let tracks = feed.value(forKeyPath: "tracks") as! NSArray
                var trackArray = [Track]()
                for track in tracks {
                    let dictionary = track as! NSDictionary
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let trackNumber = dictionary.value(forKeyPath: "track_number") as! Int
                    let discNumber = dictionary.value(forKeyPath: "disc_number") as! Int
                    let duration = dictionary.value(forKeyPath: "duration_ms") as! Int
                    let coverUrl = dictionary.value(forKeyPath: "album.images.url") as! [String]
                    let artistName = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let artistId = dictionary.value(forKeyPath: "artists.id") as! [String]
                    let albumName = dictionary.value(forKeyPath: "album.name") as! String
                    let albumId = dictionary.value(forKeyPath: "album.id") as! String
                    let track = Track(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl.first!, artistName: artistName.first!, artistId: artistId.first!, albumName: albumName, albumId: albumId)
                    trackArray.append(track)
                }
                completionHandler(trackArray)
            }
            }.resume()
    }
    
    func getAlbums(from artist: Artist, onCompletion completionHandler: @escaping ([Album])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/artists/\(artist.artistId)/albums?limit=50")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                let albums = feed.value(forKeyPath: "items") as! NSArray
                var albumArray = [Album]()
                for album in albums {
                    let dictionary = album as! NSDictionary
                    let name =  dictionary.value(forKeyPath: "name") as! String
                    let artists = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let coverUrls = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let album = Album(named: name, fromArtist: artists.first!, withCoverUrl: coverUrls.first!, withId: id)
                    albumArray.append(album)
                }
                completionHandler(albumArray)
            }
            }.resume()
    }
    
    func getPlaylist(from category: Category, onCompletion completionHandler: @escaping ([Playlist])->()) {
        let urlRequest = getURLRequest(forUrl: "https://api.spotify.com/v1/browse/categories/\(category.id)/playlists")
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                
                let playlists = feed.value(forKeyPath: "playlists.items") as! NSArray
                var playlistArray = [Playlist]()
                for playlist in playlists {
                    let dictionary = playlist as! NSDictionary
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let coverUrl = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let owner = dictionary.value(forKeyPath: "owner.id") as! String
                    let playlist = Playlist(named: name, withCoverUrl: coverUrl.first!, withId: id, fromOwner: owner)
                    playlistArray.append(playlist)
                }
                completionHandler(playlistArray)
            }
            }.resume()
    }
    
    func getSearchResults(fromUrl url: String, onCompletion completionHandler: @escaping ([Album], [Artist], [Track], [Playlist])->()) {
        let urlRequest = getURLRequest(forUrl: url)
        
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: urlRequest!) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {

                let albums = feed.value(forKeyPath: "albums.items") as! NSArray
                let artists = feed.value(forKeyPath: "artists.items") as! NSArray
                let tracks = feed.value(forKeyPath: "tracks.items") as! NSArray
                let playlists = feed.value(forKeyPath: "playlists.items") as! NSArray
                
                var albumArray = [Album]()
                for album in albums {
                    let dictionary = album as! NSDictionary
                    let name =  dictionary.value(forKeyPath: "name") as! String
                    let artists = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let coverUrls = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let album = Album(named: name, fromArtist: artists.first!, withCoverUrl: coverUrls.first ?? "", withId: id)
                    albumArray.append(album)
                }
                
                var artistArray = [Artist]()
                for artist in artists {
                    let dictionary = artist as! NSDictionary
                    let artistId = dictionary.value(forKeyPath: "id") as! String
                    let artistName = dictionary.value(forKeyPath: "name") as! String
                    let artistCoverUrl = dictionary.value(forKeyPath: "images.url") as! [String]
                    
//                    print("ARTIST")
//                    print(artistId)
//                    print(artistName)
//                    print(artistCoverUrl)
                    
                    let artist = Artist(artistId: artistId, artistName: artistName, artistCoverUrl: artistCoverUrl.first ?? "", albumIds: [])
                    artistArray.append(artist)
                }
                
                var trackArray = [Track]()
                for track in tracks {
                    let dictionary = track as! NSDictionary
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let trackNumber = dictionary.value(forKeyPath: "track_number") as! Int
                    let discNumber = dictionary.value(forKeyPath: "disc_number") as! Int
                    let duration = dictionary.value(forKeyPath: "duration_ms") as! Int
                    let coverUrl = dictionary.value(forKeyPath: "album.images.url") as! [String]
                    let artistName = dictionary.value(forKeyPath: "artists.name") as! [String]
                    let artistId = dictionary.value(forKeyPath: "artists.id") as! [String]
                    let albumName = dictionary.value(forKeyPath: "album.name") as! String
                    let albumId = dictionary.value(forKeyPath: "album.id") as! String
                    let track = Track(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl.first ?? "", artistName: artistName.first!, artistId: artistId.first!, albumName: albumName, albumId: albumId)
                    trackArray.append(track)
                }
                
                var playlistArray = [Playlist]()
                for playlist in playlists {
                    let dictionary = playlist as! NSDictionary
                    let name = dictionary.value(forKeyPath: "name") as! String
                    let coverUrl = dictionary.value(forKeyPath: "images.url") as! [String]
                    let id = dictionary.value(forKeyPath: "id") as! String
                    let owner = dictionary.value(forKeyPath: "owner.id") as! String
                    let playlist = Playlist(named: name, withCoverUrl: coverUrl.first ?? "", withId: id, fromOwner: owner)
                    playlistArray.append(playlist)
                }
                completionHandler(albumArray, artistArray, trackArray, playlistArray)
            }
            }.resume()
    }
    
    func getSpotifyString(ofType stringType: StringType, forItemType itemType: ItemType, andID id: String) -> String {
        switch stringType {
        case .hrefString:
            return "https://api.spotify.com/v1/\(itemType)/\(id)"
        case .playString:
            return "spotify:\(itemType):\(id)"
        }
    }
    
    private func getDataArray(from urlRequest: URLRequest, withKeyPath keyPath: String) -> [String]? {
        
        let urlSession = URLSession.shared
        var keyData: [String]?
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
//                print(feed)
                keyData = feed.value(forKeyPath: keyPath) as? [String]
            } else {
            }
            }.resume()
        while keyData == nil {
        }
        return keyData
    }
    
    private func getDataString(from urlRequest: URLRequest, withKeyPath keyPath: String) -> String? {
        
        let urlSession = URLSession.shared
        var keyData: String?
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let jsonData = data,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)) as? NSDictionary {
                keyData = feed.value(forKeyPath: keyPath) as? String
            } else {
            }
            }.resume()
        
        while keyData == nil {
        }

        return keyData
    }

    private func getURLRequest(forUrl url: String) -> URLRequest? {
        let userDefaults = UserDefaults.standard
        self.session = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "SpotifySession") as! Data) as? SPTSession
//        print("GETTING URL REQUEST WITH TOKEN : ")
//        print(session?.accessToken ?? "NO ACCESTOKEN")
        let urlRequest = try? SPTRequest.createRequest(for: URL(string: url) , withAccessToken: session.accessToken, httpMethod: "get", values: nil, valueBodyIsJSON: true, sendDataAsQueryString: true)
        return urlRequest
    }
    
    func getSearchUrl(for query: String, ofTypes ItemTypes: [SearchItemType], amount: Int, offSet: Int) -> String {
        let typesString = ItemTypes.map({"\($0)"}).joined(separator: ",")
        let fixedQuery = query.replacingOccurrences(of: " ", with: "-")
        let url = "https://api.spotify.com/v1/search?q=\(fixedQuery)&type=\(typesString)&limit=\(amount)&offset=\(offSet)"
//        print(url)
        return  url
    }
}
