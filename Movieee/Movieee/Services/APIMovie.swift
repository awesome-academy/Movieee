import Foundation

final class APIMovie {
    static let apiMovie = APIMovie()
    
    func getDataToAPIMovie<T: Decodable>(from path: String,
                                         completion: @escaping (T?) -> ()) {
        guard let url = URL(string: path)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    guard let safeData = data else { return }
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: safeData)
                    completion(response)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func getMovieFromGenre(from Genre: String,
                           getListMovieFromGenre: @escaping ((MovieListByGenre)?) -> Void) {
        let urlString = UrlAPIMovie.urlMovieByGenre
            + APIKeyMovie.APIKey
            + "&with_genres=\(Genre)"
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromGenre)
    }
    
    func getMovieFromCategory(from Category: String,
                              getListMovieFromCategory: @escaping ((MovieListByCategory)?) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
            + Category
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromCategory)
    }
    
    func getMovieFromSearchByMovieName(with query: String,
                                       getListMovieFromSearch: @escaping ((MovieSearchByMovieName)?) -> Void) {
        let keySearch = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = UrlAPIMovie.urlSearchMovieBy
            + "movie"
            + APIKeyMovie.APIKey
            + "&query=\(keySearch)"
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromSearch)
    }
    
    func getMovieFromSearchByPersonName(with query: String,
                                        getListMovieFromSearch: @escaping ((MovieSearchByPersonName)?) -> Void) {
        let keySearch = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = UrlAPIMovie.urlSearchMovieBy
            + "person"
            + APIKeyMovie.APIKey
            + "&query=\(keySearch)"
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromSearch)
    }
    //
    func getMovieDetail(movieId: String,
                        getMovieInDetail: @escaping ((MovieDetail)?) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
            + movieId
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieInDetail)
    }
    
    func getMovieCredits(movieId: String,
                         getMovieInCredits: @escaping ((MovieDetailCredits)?) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
            + movieId
            + "/credits"
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieInCredits)
    }
    
    func getMovieTrailer(movieId: String,
                         getMovieTrailer: @escaping ((MovieTrailer)?) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
            + movieId
            + "/videos"
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieTrailer)
    }
    
    func getPersonDetail(personId: String,
                         getPersonInDetail: @escaping ((PersonDetail)?) -> Void) {
        let urlString = UrlAPIMovie.urlPerson
            + personId
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getPersonInDetail)
    }
    
    func getPersonDetailKnownFor(personId: String,
                                 getPersonInDetailKnownFor: @escaping ((PersonDetailKnownFor)?) -> Void) {
        let urlString = UrlAPIMovie.urlPerson
            + personId
            + "/movie_credits"
            + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getPersonInDetailKnownFor)
    }
    
}
