import Foundation
import Vision
import Translation

public class RealtimeTranslator {
    
    private var translator: Translator?
    private var onTranslation: ((String) -> Void)?
    
    public init(sourceLanguage: String, targetLanguage: String) {
        // ตั้งค่าภาษาต้นทางและปลายทาง
        // (ในเวอร์ชันเต็มจะใช้ Locale จริง)
        setupTranslator()
    }
    
    private func setupTranslator() {
        // ใช้ Apple Translate Framework (on-device)
        translator = Translator.translator(between: .english, and: .thai)
        
        // ดาวน์โหลดโมเดลภาษา (ทำครั้งแรกเท่านั้น)
        translator?.download { result in
            switch result {
            case .success:
                print("✅ ดาวน์โหลดโมเดลภาษาเรียบร้อย")
            case .failure(let error):
                print("❌ ดาวน์โหลดล้มเหลว: \(error)")
            }
        }
    }
    
    public func extractAndTranslate(from image: CGImage, completion: @escaping (String) -> Void) {
        onTranslation = completion
        
        // สร้างคำขอ OCR
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let recognizedText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !recognizedText.isEmpty else { return }
            
            // แปลภาษา
            self?.translator?.translate(recognizedText) { result in
                if case .success(let translation) = result {
                    self?.onTranslation?(translation)
                }
            }
        }
        
        request.recognitionLevel = .fast
        request.recognitionLanguages = ["en-US", "ja-JP", "zh-Hant"]
        
        // ประมวลผลภาพ
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try? handler.perform([request])
    }
}
