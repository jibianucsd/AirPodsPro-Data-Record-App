/*
See the License.txt file for this sample’s licensing information.
*/

import CoreMotion
import UIKit

class AirpodsMotionDetector: ObservableObject {
    let motionManager = CMHeadphoneMotionManager()

    private var timer = Timer()
    private var updateInterval: TimeInterval

    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var zAcceleration: Double = 0

    var onUpdate: ((CMDeviceMotion) -> Void) = {_ in }
    
    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    let orientationNotification = UIDevice.orientationDidChangeNotification

    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    func start() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        orientationObserver = NotificationCenter.default.addObserver(forName: orientationNotification, object: nil, queue: .main) { [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .unknown:
                break
            default:
                self?.currentOrientation = UIDevice.current.orientation
            }
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Device motion not available")
        }
    }
    
    func updateMotionData() {
        if let data = motionManager.deviceMotion {
            onUpdate(data)
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: orientationNotification, object: nil)
        }
        orientationObserver = nil
    }

    deinit {
        stop()
    }
}

extension AirpodsMotionDetector {
    func started() -> AirpodsMotionDetector {
        start()
        return self
    }
}
