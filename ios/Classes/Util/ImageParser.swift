import ARKit
import Foundation

func parseReferenceImagesSet(_ images: [[String: Any]]) -> Set<ARReferenceImage> {
    let conv = images.compactMap { parseReferenceImage($0) }
    return Set(conv)
}

func parseReferenceImage(_ dict: [String: Any]) -> ARReferenceImage? {
    if let physicalWidth = dict["physicalWidth"] as? Double,
       let name = dict["name"] as? String,
       let image = getImageByName(name),
       let cgImage = image.cgImage
    {
        let referenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(physicalWidth))
        referenceImage.name = name
        return referenceImage
    }
    return nil
}

func getImageByName(_ name: String) -> UIImage? {
    if let img = UIImage(named: name) {
        return img
    }

    if let url = URL(string: name) {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {}
    }
    if let base64 = Data(base64Encoded: name, options: .ignoreUnknownCharacters) {
        return UIImage(data: base64)
    }
    return nil
}
