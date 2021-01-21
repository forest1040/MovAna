import Foundation
import Vision
import AVFoundation

public class MovAna {
    private var requests = [VNRequest]()

    init () {
        setupVision()
    }
    
    func setupVision() {
        if let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") {
            let mlModel = try! VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let mlRequest = VNCoreMLRequest(model: mlModel, completionHandler: { (request, error) in
                let results = request.results!
                print("Found \(results.count) objects")
                for item in results {
                    let object = item as! VNRecognizedObjectObservation
                    print("\(object.labels[0].identifier) \(object.confidence) \(object.boundingBox)")
                }
            })
            self.requests = [mlRequest]
        }
    }

    func processMovie(url: URL?) {
        let asset = AVURLAsset(url: url!, options: nil)
        let reader = try! AVAssetReader(asset: asset)
        let videoTrack = asset.tracks(withMediaType: .video).first!
        let outputSettings = [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)]
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack,
                                                        outputSettings: outputSettings)
        reader.add(trackReaderOutput)
        reader.startReading()

        // フレームごとに画像を読み込む
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() { // CMSampleBuffer
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) { // CVImageBuffer (CVPixelBuffer)
                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
                // 画像の処理を実行する
                try! imageRequestHandler.perform(self.requests)
            }
        }
    }
}
