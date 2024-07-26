package io.carius.lars.ar_flutter_plugin_flutterflow

import com.google.ar.sceneform.AnchorNode
import com.google.ar.sceneform.Node
import com.google.ar.sceneform.math.Quaternion
import com.google.ar.sceneform.math.Vector3
import com.google.ar.sceneform.rendering.Renderable
import io.carius.lars.ar_flutter_plugin_flutterflow.VideoScaleType.*

class VideoAnchorNode() : AnchorNode() {
    var videoName: String
        get() = videoNode.name
        set(value) {
            videoNode.name = value
        }
    var videoScaleXYZ: Vector3? = null
    private val videoNode = Node().also { it.setParent(this) }

    override fun setRenderable(renderable: Renderable?) {
        videoNode.renderable = renderable
    }

    fun setVideoProperties(
        videoWidth: Float, videoHeight: Float, videoRotation: Float,
        imageWidth: Float, imageHeight: Float,
        videoScaleType: VideoScaleType,
    ) {
        scaleNode(videoWidth, videoHeight, imageWidth, imageHeight, videoScaleType, videoScaleXYZ)
        rotateNode(videoRotation)
    }

    private fun scaleNode(
        videoWidth: Float, videoHeight: Float,
        imageWidth: Float, imageHeight: Float,
        videoScaleType: VideoScaleType, scaleFitXYZ: Vector3?
    ) {
        videoNode.localScale = when (videoScaleType) {
            FitXY -> scaleFitXY(imageWidth, imageHeight)
            CenterCrop -> scaleCenterCrop(videoWidth, videoHeight, imageWidth, imageHeight)
            CenterInside -> scaleCenterInside(videoWidth, videoHeight, imageWidth, imageHeight)
            FixSize -> scaleFitXYZ( videoWidth, videoHeight, scaleFitXYZ!!)

        }
    }

    private fun rotateNode(videoRotation: Float) {
        videoNode.localRotation = Quaternion.axisAngle(Vector3(0.0f, -1.0f, 0.0f), videoRotation)
    }

    private fun scaleFitXY(imageWidth: Float, imageHeight: Float) = Vector3(imageWidth, 1.0f, imageHeight)

    private fun scaleCenterCrop(videoWidth: Float, videoHeight: Float, imageWidth: Float, imageHeight: Float): Vector3 {
        val isVideoVertical = videoHeight > videoWidth
        val videoAspectRatio = if (isVideoVertical) videoHeight / videoWidth else videoWidth / videoHeight
        val imageAspectRatio = if (isVideoVertical) imageHeight / imageWidth else imageWidth / imageHeight

        return if (isVideoVertical) {
            if (videoAspectRatio > imageAspectRatio) {
                Vector3(imageWidth, 1.0f, imageWidth * videoAspectRatio)
            } else {
                Vector3(imageHeight / videoAspectRatio, 1.0f, imageHeight)
            }
        } else {
            if (videoAspectRatio > imageAspectRatio) {
                Vector3(imageHeight * videoAspectRatio, 1.0f, imageHeight)
            } else {
                Vector3(imageWidth, 1.0f, imageWidth / videoAspectRatio)
            }
        }
    }

    private fun scaleCenterInside(videoWidth: Float, videoHeight: Float, imageWidth: Float, imageHeight: Float): Vector3 {
        val isVideoVertical = videoHeight > videoWidth
        val videoAspectRatio = if (isVideoVertical) videoHeight / videoWidth else videoWidth / videoHeight
        val imageAspectRatio = if (isVideoVertical) imageHeight / imageWidth else imageWidth / imageHeight

        return if (isVideoVertical) {
            if (videoAspectRatio < imageAspectRatio) {
                Vector3(imageWidth, 1.0f, imageWidth * videoAspectRatio)
            } else {
                Vector3(imageHeight / videoAspectRatio, 1.0f, imageHeight)
            }
        } else {
            if (videoAspectRatio < imageAspectRatio) {
                Vector3(imageHeight * videoAspectRatio, 1.0f, imageHeight)
            } else {
                Vector3(imageWidth, 1.0f, imageWidth / videoAspectRatio)
            }
        }
    }
    private fun scaleFitXYZ(videoWidth: Float, videoHeight: Float, scaleFitXYZ: Vector3) : Vector3 {
        val isVideoVertical = videoHeight > videoWidth
        val videoAspectRatio = if (isVideoVertical) videoHeight / videoWidth else videoWidth / videoHeight
        return Vector3(scaleFitXYZ.x * videoAspectRatio, scaleFitXYZ.y * videoAspectRatio, scaleFitXYZ.z * videoAspectRatio)
    }
}