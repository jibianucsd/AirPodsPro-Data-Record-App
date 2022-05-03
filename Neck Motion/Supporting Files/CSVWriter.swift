import Foundation
import CoreMotion

class CSVWriter {
    
    var timestamp:String = ""
    var counter = 0
    var file: FileHandle?

    func open(_ filePath: URL) {
        do {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            file = try FileHandle(forWritingTo: filePath)
            header()
        } catch let e {
            print(e)
        }
    }
    
    func header(){
        let header = """
                    Count,Timestamp,AttitudePitch,AttitudeRoll,AttitudeYaw,DegreePitch,DegreeRoll,DegreeYaw,\
                    QuaternionX,QuaternionY,QuaternionZ,QuaternionW,\
                    GravitationalAccelerationX,GravitationalAccelerationY,GravitationalAccelerationZ,\
                    AccelerationX,AccelerationY,AccelerationZ,\
                    RotationX,RotationY,RotationZ\n
                    """
        file!.write(header.data(using: .utf8)!)
    }
    
    func write(_ motion: CMDeviceMotion){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSSS"
        timestamp = format.string(from: date)
        
        counter += 1
        
        guard let file = self.file else { return}
        var text = """
                \(counter),\(timestamp),\(motion.attitude.pitch),\(motion.attitude.roll),\(motion.attitude.yaw),\(degree(motion.attitude.pitch)),\(degree(motion.attitude.roll)),\(degree(motion.attitude.yaw)),\
                \(motion.attitude.quaternion.x),\(motion.attitude.quaternion.y),\(motion.attitude.quaternion.z),\(motion.attitude.quaternion.w),\
                \(motion.gravity.x),\(motion.gravity.y),\(motion.gravity.z),\
                \(motion.userAcceleration.x),\(motion.userAcceleration.y),\(motion.userAcceleration.z),\
                \(motion.rotationRate.x),\(motion.rotationRate.y),\(motion.rotationRate.z)
                """
        text = text.trimmingCharacters(in: .newlines) + "\n"
        file.write(text.data(using: .utf8)!)
    }
    
    func degree(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    func close() {
        guard let _ = self.file else { return }
        file!.closeFile()
        file = nil
    }
}
