import UIKit
import WebKit

final class TrailerDetailViewController: UIViewController {
    @IBOutlet private weak var videoUtubeWebView: WKWebView!
    private var keyForUtubeVideo = ""
    var idFilm = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTrailerDetail(for: "\(idFilm)")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configTrailerDetail(for key: String) {
        APIMovie.apiMovie.getMovieTrailer(movieId: key) { [unowned self] result in
            if let result = result {
                keyForUtubeVideo = result.results[0].key
            }
            playUtubeVideo(with: keyForUtubeVideo)
        }
    }
    
    private func playUtubeVideo(with key: String) {
        guard let url = URL(string: UrlAPIMovie.urlVideoEmbedYoutube + key)
        else { return }
        let request = URLRequest(url: url)
        videoUtubeWebView.load(request)
    }
}
