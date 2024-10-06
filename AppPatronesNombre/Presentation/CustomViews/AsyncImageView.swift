import UIKit

//vamos a utilizar esta función para transformar las url de las imagenes en UIImage
final class AsyncImageView: UIImageView {
    
    private var workItem: DispatchWorkItem?
    
    func setImage(_ string: String) { //Sobrecargamos el nombre de la funci´n para que este setImage llame por denajo al otro setImage. De tal manera que el de String llamará al de URL
        if let url = URL(string: string) {
            setImage(url)
        }
    }
    
    func setImage(_ url: URL) {
        let workItem = DispatchWorkItem {
                let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
                print("loading image")
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    self?.workItem = nil
                }
        }
        
        DispatchQueue.global().async(execute: workItem)
        self.workItem = workItem
    }
    
    func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
