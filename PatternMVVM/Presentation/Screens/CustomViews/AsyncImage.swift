import UIKit

final class AsyncImage: UIImageView {
    private var dispatchWorkItem: DispatchWorkItem?
    
    func setImage(_ image: String) {
        cancel()
        if let url = URL(string: image) {
            setImage(url)
        }
    }
    
    func setImage(_ image: URL) {
        cancel()
        let workItem = DispatchWorkItem {
            let image = (try? Data(contentsOf: image)).flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { [weak self] in
                self?.image = image ?? UIImage()
                self?.dispatchWorkItem = nil
            }
        }
        DispatchQueue.global().async(execute: workItem)
        self.dispatchWorkItem = workItem
    }
    
    func cancel() {
        dispatchWorkItem?.cancel()
        dispatchWorkItem = nil
    }
}
