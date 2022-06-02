import Foundation
import CoreMotion
import UIKit

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

class CSVWriter {
    
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
                    Timestamp,QuaternionX,QuaternionY,QuaternionZ,QuaternionW,\
                    AttitudePitch,AttitudeRoll,AttitudeYaw,\
                    GravitationalAccelerationX,GravitationalAccelerationY,GravitationalAccelerationZ,\
                    AccelerationX,AccelerationY,AccelerationZ,\
                    RotationX,RotationY,RotationZ\n
                    """
//        print(header)
        file!.write(header.data(using: .utf8)!)
    }
    
    func write(_ motion: CMDeviceMotion) {
        let timestamp = Date().currentTimeMillis()
        guard let file = self.file else { return }
        var text = """
                \(timestamp),\(motion.attitude.quaternion.x),\(motion.attitude.quaternion.y),\(motion.attitude.quaternion.z),\(motion.attitude.quaternion.w),\
                \(motion.attitude.pitch),\(motion.attitude.roll),\(motion.attitude.yaw),\
                \(motion.gravity.x),\(motion.gravity.y),\(motion.gravity.z),\
                \(motion.userAcceleration.x),\(motion.userAcceleration.y),\(motion.userAcceleration.z),\
                \(motion.rotationRate.x),\(motion.rotationRate.y),\(motion.rotationRate.z)
                """
        text = text.trimmingCharacters(in: .newlines) + "\n"
        file.write(text.data(using: .utf8)!)
    }
    
    private func writeMotionData(motion: MotionData) {
        for i in 0..<motion.timestamps.count {
            writeLine(motion: motion, index: i)
        }
    }
    
    private func writeLine(motion: MotionData, index: Int) {
        guard let file = self.file else { return }
        var text = """
                \(motion.timestamps[index]),\
                \(motion.quaternionX[index]),\
                \(motion.quaternionY[index]),\
                \(motion.quaternionZ[index]),\
                \(motion.quaternionW[index]),\
                \(motion.attitudePitch[index]),\
                \(motion.attitudeRoll[index]),\
                \(motion.attitudeYaw[index]),\
                \(motion.gravAccelX[index]),\
                \(motion.gravAccelY[index]),\
                \(motion.gravAccelZ[index]),\
                \(motion.accelX[index]),\
                \(motion.accelY[index]),\
                \(motion.accelZ[index]),\
                \(motion.rotationX[index]),\
                \(motion.rotationY[index]),\
                \(motion.rotationZ[index])
                """
        text = text.trimmingCharacters(in: .newlines) + "\n"
        print(text)
        file.write(text.data(using: .utf8)!)
    }
    
    func writeSession(session: Session) {
        print("Writing session with ", session.motion.timestamps.count, " datapoints")
        let dir = FileManager.default.urls(
          for: .documentDirectory,
          in: .userDomainMask
        ).first!
        
        let now = session.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        
        let filename = formatter.string(from: now) + "_" + session.type + "_motion.csv"
        
        let fileUrl = dir.appendingPathComponent(filename)
        open(fileUrl)
        writeMotionData(motion: session.motion)
        
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        let path = getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        let url = URL(string: path)!
        UIApplication.shared.open(url)
        
        close()
    }
    
    func close() {
        guard let _ = self.file else { return }
        file!.closeFile()
        file = nil
    }
}
