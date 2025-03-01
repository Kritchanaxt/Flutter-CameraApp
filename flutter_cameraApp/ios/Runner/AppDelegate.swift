//import UIKit
//import Flutter
//
//@main
//@objc class AppDelegate: FlutterAppDelegate {
//    private let channel = "com.example.camera"  // กำหนดชื่อช่องทาง
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        GeneratedPluginRegistrant.register(with: self)
//        let controller = window?.rootViewController as! FlutterViewController
//        let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)
//        
//        methodChannel.setMethodCallHandler { (call, result) in
//            if call.method == "openNativeCamera" {
//                self.openCamera()
//                result(nil)
//            } else {
//                result(FlutterMethodNotImplemented)
//            }
//        }
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//    
//    private func openCamera() {
//        // เปิดกล้อง native
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
//            window?.rootViewController?.present(picker, animated: true, completion: nil)
//        }
//    }
//
//    
//}
//

import UIKit
import AVFoundation
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var movieOutput: AVCaptureMovieFileOutput?
    
    private let channel = "com.example.camera"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler { (call, result) in
            if call.method == "openNativeCamera" {  // ✅ เพิ่ม openNativeCamera
                self.openNativeCamera()
                result(nil)
            } else if call.method == "startVideoRecording" {
                self.startVideoRecording(result: result)
            } else if call.method == "stopVideoRecording" {
                self.stopVideoRecording(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        setupCamera()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func openNativeCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                self.window?.rootViewController?.present(picker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }
    }

    private func startVideoRecording(result: @escaping FlutterResult) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            result(FlutterError(code: "CAMERA_NOT_READY", message: "Camera is not initialized", details: nil))
            return
        }

        let outputDirectory = FileManager.default.temporaryDirectory
        let outputURL = outputDirectory.appendingPathComponent(UUID().uuidString + ".mov")

        resultCallback = result
        movieOutput?.startRecording(to: outputURL, recordingDelegate: self)
    }

    private func stopVideoRecording(result: @escaping FlutterResult) {
        if movieOutput?.isRecording == true {
            resultCallback = result
            movieOutput?.stopRecording()
        } else {
            result(FlutterError(code: "NOT_RECORDING", message: "No active recording found", details: nil))
        }
    }

    private func setupCamera() {
        requestPermissions { granted in
            guard granted else {
                print("Camera/Microphone permissions not granted")
                return
            }

            self.captureSession = AVCaptureSession()
            guard let captureSession = self.captureSession else { return }

            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  captureSession.canAddInput(videoDeviceInput) else {
                return
            }
            
            captureSession.addInput(videoDeviceInput)

            guard let audioDevice = AVCaptureDevice.default(for: .audio),
                  let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice),
                  captureSession.canAddInput(audioDeviceInput) else {
                return
            }

            captureSession.addInput(audioDeviceInput)

            self.movieOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.movieOutput!) {
                captureSession.addOutput(self.movieOutput!)
            }

            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.videoPreviewLayer?.videoGravity = .resizeAspectFill
            self.videoPreviewLayer?.frame = self.window!.bounds
            self.window?.layer.addSublayer(self.videoPreviewLayer!)

            captureSession.startRunning()
        }
    }

    private func requestPermissions(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)

        if cameraStatus == .authorized && microphoneStatus == .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { videoGranted in
                AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                    DispatchQueue.main.async {
                        completion(videoGranted && audioGranted)
                    }
                }
            }
        }
    }
    
    private var resultCallback: FlutterResult?
}

extension AppDelegate: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
            resultCallback?(FlutterError(code: "VIDEO_ERROR", message: error.localizedDescription, details: nil))
        } else {
            print("Video saved at \(outputFileURL)")
            resultCallback?(outputFileURL.path)
        }
        resultCallback = nil
    }
}
