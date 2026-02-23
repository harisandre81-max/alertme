package com.example.alertme

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.KeyEvent
import android.os.Handler
import android.os.Looper
import android.content.Intent
import android.net.Uri
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.FusedLocationProviderClient
import android.annotation.SuppressLint

class SOSAccessibilityService : AccessibilityService() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var isPressed = false
    private val handler = Handler(Looper.getMainLooper())

    private val longPressRunnable = Runnable {
        if (isPressed) {
            triggerSOS()
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {}

    override fun onKeyEvent(event: KeyEvent): Boolean {

        if (event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {

            when (event.action) {

                KeyEvent.ACTION_DOWN -> {
                    isPressed = true
                    handler.postDelayed(longPressRunnable, 3000)
                }

                KeyEvent.ACTION_UP -> {
                    isPressed = false
                    handler.removeCallbacks(longPressRunnable)
                }
            }
        }

        return super.onKeyEvent(event)
    }

    @SuppressLint("MissingPermission")
    private fun triggerSOS() {

        val locationRequest = com.google.android.gms.location.LocationRequest.Builder(
            com.google.android.gms.location.Priority.PRIORITY_HIGH_ACCURACY,
            1000
        ).build()

        val builder = com.google.android.gms.location.LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest)

        val settingsClient = com.google.android.gms.location.LocationServices
            .getSettingsClient(this)

        val task = settingsClient.checkLocationSettings(builder.build())

        task.addOnSuccessListener {

            // 🔥 GPS ya está activo
            requestRealLocation(locationRequest)

        }.addOnFailureListener { exception ->

            if (exception is com.google.android.gms.common.api.ResolvableApiException) {

                try {
                    val intent = Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    startActivity(intent
                    )
                } catch (sendEx: Exception) {
                    sendBasicSOS()
                }

            } else {
                sendBasicSOS()
            }
        }
    }
    @SuppressLint("MissingPermission")
    private fun requestRealLocation(locationRequest: com.google.android.gms.location.LocationRequest) {

        val locationCallback = object : com.google.android.gms.location.LocationCallback() {
            override fun onLocationResult(locationResult: com.google.android.gms.location.LocationResult) {

                val location = locationResult.lastLocation

                if (location != null) {

                    val lat = location.latitude
                    val lng = location.longitude

                    val message = "🚨 AYUDA! Necesito asistencia médica inmediata.\nMi ubicación:\nhttps://maps.google.com/?q=$lat,$lng"

                    val intent = Intent(Intent.ACTION_VIEW).apply {
                        data = Uri.parse("sms:")
                        putExtra("sms_body", message)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }

                    startActivity(intent)

                    fusedLocationClient.removeLocationUpdates(this)
                }
            }
        }

        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()
        )
    }

    private fun sendBasicSOS() {

        val message = "🚨 AYUDA! Necesito asistencia médica inmediata. (Ubicación no disponible)"

        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse("sms:")
            putExtra("sms_body", message)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        startActivity(intent)
    }
}