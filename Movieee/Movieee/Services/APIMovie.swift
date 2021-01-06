import Foundation

final class APIMovie {
    static let apiMovie = APIMovie()
    
    func getDataToAPIMovie<T: Decodable>(from path: String,
                                         completion: @escaping (T) -> ()) {
        guard let url = URL(string: path)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let safeData = data else { return }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: safeData)
                completion(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getMovieFromGenre(from Genre: String,
                           getListMovieFromGenre: @escaping (_ result : MovieListByGenre) -> Void) {
        let urlString = UrlAPIMovie.urlMovieByGenre
                        + APIKeyMovie.APIKey
                        + "&with_genres=\(Genre)"
        getDataToAPIMovie(from: urlString, completion: getListMovieFromGenre)
    }
    
    func getMovieFromCategory(from Category: String,
                              getListMovieFromCategory: @escaping (_ result : MovieListByCategory) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
                        + Category
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromCategory)
    }
    
    func getMovieFromSearchByMovieName(with query: String,
                                       getListMovieFromSearch: @escaping (_ result : MovieSearchByMovieName) -> Void) {
        let urlString = UrlAPIMovie.urlSearchMovieBy
                        + "movie"
                        + APIKeyMovie.APIKey
                        + "&query=\(query)"
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromSearch)
    }
    
    func getMovieFromSearchByPersonName(with query: String,
                                       getListMovieFromSearch: @escaping (_ result : MovieSearchByPersonName) -> Void) {
        let urlString = UrlAPIMovie.urlSearchMovieBy
                        + "person"
                        + APIKeyMovie.APIKey
                        + "&query=\(query)"
        getDataToAPIMovie(from: urlString,
                          completion: getListMovieFromSearch)
    }
    
    func getMovieDetail(movieId: String,
                        getMovieInDetail: @escaping (_ result : MovieDetail) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
                        + movieId
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieInDetail)
    }
    
    func getMovieCredits(movieId: String,
                         getMovieInCredits: @escaping (_ result : MovieDetailCredits) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
                        + movieId
                        + "/credits"
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieInCredits)
    }
    
    func getMovieTrailer(movieId: String,
                         getMovieTrailer: @escaping (_ result : MovieTrailer) -> Void) {
        let urlString = UrlAPIMovie.urlMovie
                        + movieId
                        + "/videos"
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getMovieTrailer)
    }
    
    func getPersonDetail(personId: String,
                         getPersonInDetail: @escaping (_ result : PersonDetail) -> Void) {
        let urlString = UrlAPIMovie.urlPerson
                        + personId
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getPersonInDetail)
    }
    
    func getPersonDetailKnownFor(personId: String,
                                 getPersonInDetailKnownFor: @escaping (_ result : PersonDetailKnownFor) -> Void) {
        let urlString = UrlAPIMovie.urlPerson
                        + personId
                        + "/movie_credits"
                        + APIKeyMovie.APIKey
        getDataToAPIMovie(from: urlString,
                          completion: getPersonInDetailKnownFor)
    }
    
}
