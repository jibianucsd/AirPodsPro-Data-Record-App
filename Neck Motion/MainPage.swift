import Foundation
import UIKit
import SceneKit
import CoreMotion

class MainPage: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    let AirPods = CMHeadphoneMotionManager()
    let writer = CSVWriter()
    let f = DateFormatter()
    var write: Bool = false
    
    var cubeNode: SCNNode!
    
    lazy var button_start: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size.width = 110
        button.frame.size.height = 55
        button.frame = CGRect(x: self.view.frame.size.width/2 - button.frame.size.width/2, y: self.view.frame.size.height/2 - button.frame.size.height/2 + 180, width: button.frame.width, height: button.frame.height)
        button.clipsToBounds = true
        button.setImage(UIImage(named: "pause.png"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size:18)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 14
        
        button.addTarget(self, action: #selector(tap_start), for: .touchUpInside)
        return button
    }()
    
    lazy var button_file: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size.width = 110
        button.frame.size.height = 55
        button.frame = CGRect(x: self.view.frame.size.width/2 - button.frame.size.width/2, y: self.view.frame.size.height/2 - button.frame.size.height/2 + 250, width: button.frame.width, height: button.frame.height)
        button.clipsToBounds = true
        button.setImage(UIImage(named: "file.png"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size:18)
        button.backgroundColor = .systemOrange
        
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(tap_file), for: .touchUpInside)
        return button
    }()
    
    lazy var stausView: UITextView = {
        let view = UITextView()
        view.frame.size.width = 150
        view.frame.size.height = 50
        view.frame = CGRect(x: self.view.frame.size.width/2 - view.frame.size.width/2, y: self.view.frame.size.height/2 - view.frame.size.height/2 - 50, width: view.frame.width, height: view.frame.height)
        
        view.text = "Disconnect"
        view.textColor = .systemRed
        
        view.textAlignment = .center
        
        view.backgroundColor = .systemGray6
        view.font = view.font?.withSize(18)
        view.isEditable = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        f.dateFormat = "yyyyMMdd_HHmmss"
        AirPods.delegate = self
        
        view.backgroundColor = .systemGray6
        view.addSubview(button_start)
        view.addSubview(button_file)
        view.addSubview(stausView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        super.viewWillAppear(animated)
        
        // Hide controller bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        write = false
        writer.close()
        AirPods.stopDeviceMotionUpdates()
        button_start.setTitle("Start", for: .normal)
        
        // Hide controller bar
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func start() {
        guard AirPods.isDeviceMotionAvailable else { return }
        AirPods.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion, error == nil else { return }
            self?.writer.write(motion)
            self?.printStatus(motion)
        })
    }
    
    @objc func tap_start() {
        if write {
            write.toggle()
            writer.close()
            AirPods.stopDeviceMotionUpdates()
            button_start.setImage(UIImage(named: "pause.png"), for: .normal)
            button_start.backgroundColor = .systemIndigo
        } else {
            write.toggle()
            button_start.setImage(UIImage(named: "play.png"), for: .normal)
            button_start.backgroundColor = .systemRed
            let dir = FileManager.default.urls(
              for: .documentDirectory,
              in: .userDomainMask
            ).first!
            
            let now = Date()
            let filename = f.string(from: now) + "_motion.csv"
            
            let fileUrl = dir.appendingPathComponent(filename)
            writer.open(fileUrl)
            start()
        }
    }
    
    @objc func tap_file() {
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        let path = getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        let url = URL(string: path)!
        UIApplication.shared.open(url)
    }
    
    func printStatus(_ data: CMDeviceMotion) {
        
        var output_result = "Normal"
        self.stausView.textColor = .white
        
        if (data.attitude.pitch <= -0.25 || data.attitude.pitch >= 0.25) {
            output_result = "Warning"
            self.stausView.textColor = .systemYellow
        }
        
        self.stausView.text = output_result
    }
}
