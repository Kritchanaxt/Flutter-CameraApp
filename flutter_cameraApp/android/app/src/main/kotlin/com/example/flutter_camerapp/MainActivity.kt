package com.example.flutter_camerapp

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

import androidx.camera.core.VideoCapture  // Must import VideoCapture
import io.flutter.embedding.engine.FlutterEngine
import androidx.camera.view.PreviewView  // Import PreviewView to set up the surface provider

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.camera"
    private var cameraProvider: ProcessCameraProvider? = null
    private var camera: Camera? = null
    private var videoCapture: VideoCapture? = null
    private var outputDirectory: File? = null
    private lateinit var cameraExecutor: ExecutorService

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openNativeCamera" -> openNativeCamera()
                "startVideoRecording" -> startVideoRecording(result)
                "stopVideoRecording" -> stopVideoRecording(result)
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cameraExecutor = Executors.newSingleThreadExecutor()
        outputDirectory = getOutputDirectory()
        startCamera()
    }

    private fun openNativeCamera() {
        // Open the native camera app (optional)
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()
            val preview = Preview.Builder().build().also {
                val previewView: PreviewView = findViewById(R.id.previewView)  // Assuming you have a PreviewView in your layout
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            videoCapture = VideoCapture.Builder()
                .setTargetRotation(this.windowManager.defaultDisplay.rotation)
                .build()

            try {
                cameraProvider?.unbindAll()
                camera = cameraProvider?.bindToLifecycle(this, cameraSelector, preview, videoCapture)
            } catch (exc: Exception) {
                Log.e("CameraX", "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }

    private fun startVideoRecording(result: MethodChannel.Result) {
        if (videoCapture == null) {
            result.error("VIDEO_ERROR", "Video capture is not initialized", null)
            return
        }

        val videoFile = File(outputDirectory, "VID_${SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())}.mp4")
        val outputOptions = VideoCapture.OutputFileOptions.Builder(videoFile).build()

        videoCapture?.startRecording(outputOptions, cameraExecutor, object : VideoCapture.OnVideoSavedCallback {
            override fun onVideoSaved(outputFileResults: VideoCapture.OutputFileResults) {
                result.success(outputFileResults.savedUri?.path ?: videoFile.absolutePath)
            }

            override fun onError(videoCaptureError: Int, message: String, cause: Throwable?) {
                result.error("VIDEO_ERROR", message, cause?.message)
            }
        })
    }

    private fun stopVideoRecording(result: MethodChannel.Result) {
        videoCapture?.stopRecording()
        result.success("Video recording stopped")
    }

    private fun getOutputDirectory(): File {
        val mediaDir = externalMediaDirs.firstOrNull()?.let {
            File(it, "camera").apply { mkdirs() }
        }
        return mediaDir?.takeIf { it.exists() } ?: filesDir
    }

    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
    }
}
