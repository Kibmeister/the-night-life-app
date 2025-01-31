import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?
    private var task: URLSessionDataTask?
    
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.url = url
        
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
} 