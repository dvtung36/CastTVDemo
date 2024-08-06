package com.example.cast;


import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.util.Log;
import android.widget.Toast;

import static com.connectsdk.service.DeviceService.PairingType.PIN_CODE;

import com.connectsdk.device.ConnectableDevice;
import com.connectsdk.device.ConnectableDeviceListener;
import com.connectsdk.device.DevicePicker;
import com.connectsdk.discovery.DiscoveryManager;
import com.connectsdk.discovery.DiscoveryManager.PairingLevel;
import com.connectsdk.service.capability.KeyControl;
import com.connectsdk.service.capability.PowerControl;
import com.connectsdk.service.capability.TVControl;
import com.connectsdk.service.DeviceService;
import com.connectsdk.service.DeviceService.PairingType;
import com.connectsdk.service.capability.MediaPlayer;
import com.connectsdk.service.command.ServiceCommandError;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "unisoft_cast_tv";
    private DiscoveryManager mDiscoveryManager;
    private ConnectableDevice mTV;

    private ConnectableDeviceListener deviceListener = new ConnectableDeviceListener() {

        @Override
        public void onConnectionFailed(ConnectableDevice device, ServiceCommandError error) {
            Log.d("2ndScreenAPP", "onConnectFailed");
            connectFailed(mTV);
        }

        @Override
        public void onDeviceReady(ConnectableDevice device) {
            Log.d("2ndScreenAPP", "onPairingSuccess");
            Log.d("2ndScreenAPP", "Thiết bị: " + device.getModelName() + " (ID: " + device.getId() + ")");
            checkDeviceCapabilities(device);
            registerSuccess(mTV);
        }

        @Override
        public void onDeviceDisconnected(ConnectableDevice device) {
            Log.d("2ndScreenAPP", "Device Disconnected");
            connectEnded(mTV);
            Toast.makeText(getApplicationContext(), "Device Disconnected", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onPairingRequired(ConnectableDevice device, DeviceService service, PairingType pairingType) {


            Log.d("2ndScreenAPP", "Connected to " + mTV.getIpAddress());
            Log.d("PairingType", "PairingType: " + pairingType.name());
            switch (pairingType) {
                case FIRST_SCREEN:
                    Log.d("2ndScreenAPP", "First Screen");
                    break;

                case PIN_CODE:
                case MIXED:
                    Log.d("2ndScreenAPP", "Pin Code");
                    break;

                case NONE:
                default:
                    Log.d("PairingType", "No Pairing Required");
                    break;
            }
        }

        @Override
        public void onCapabilityUpdated(ConnectableDevice device, List<String> added, List<String> removed) {

        }
    };


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("scan_device")) {
                                ///TODO
                            } else if (call.method.equals("get_list_device")) {
                                List<Map<String, String>> devices = getDevices();
                                result.success(devices);
                            } else if (call.method.equals("connect_device")) {
                                ///TODO
                            } else if (call.method.equals("cast_image")) {
                                ///TODO
                            } else if (call.method.equals("cast_video")) {
                                ///TODO
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    // Bắt đầu quét các thiết bị
    public void startDiscovery() {
        mDiscoveryManager = DiscoveryManager.getInstance();
        mDiscoveryManager.registerDefaultDeviceTypes();
        mDiscoveryManager.setPairingLevel(PairingLevel.ON);
        DiscoveryManager.getInstance().start();
    }

    // Dừng quét các thiết bị
    public void stopDiscovery() {
        DiscoveryManager.getInstance().stop();
    }

    // Kết nối với thiết bị đã chọn
    public void connectToDevice(ConnectableDevice device) {
        if (device != null) {
            mTV = device;
            mTV.addListener(deviceListener);
            mTV.setPairingType(PIN_CODE);
            mTV.connect();
        }
    }

    // Xử lý khi kết nối thiết bị thành công
    void registerSuccess(ConnectableDevice device) {
        Log.d("2ndScreenAPP", "successful register");
    }

    // Xử lý khi kết nối thiết bị thất bại
    void connectFailed(ConnectableDevice device) {
        if (device != null)
            Log.d("2ndScreenAPP", "Failed to connect to " + device.getIpAddress());

        if (mTV != null) {
            mTV.removeListener(deviceListener);
            mTV.disconnect();
            mTV = null;
        }
    }

    // Xử lý khi kết nối thiết bị kết thúc
    void connectEnded(ConnectableDevice device) {

        if (!mTV.isConnected()) {
            mTV.removeListener(deviceListener);
            mTV = null;
        }
    }


    // Kiểm tra các khả năng của thiết bị
    private void checkDeviceCapabilities(ConnectableDevice device) {
        if (device.hasCapability(TVControl.class.getName())) {
            Log.d("2ndScreenAPP", "Thiết bị hỗ trợ TVControl.");
        } else {
            Log.e("2ndScreenAPP", "Thiết bị không hỗ trợ TVControl.");
        }

        if (device.hasCapability(PowerControl.class.getName())) {
            Log.d("2ndScreenAPP", "Thiết bị hỗ trợ PowerControl.");
        } else {
            Log.e("2ndScreenAPP", "Thiết bị không hỗ trợ PowerControl.");
        }

        if (device.hasCapability(MediaPlayer.class.getName())) {
            Log.d("2ndScreenAPP", "Thiết bị hỗ trợ MediaPlayer.");
        } else {
            Log.e("2ndScreenAPP", "Thiết bị không hỗ trợ MediaPlayer.");
        }
    }

    private List<Map<String, String>> getDevices() {
        List<Map<String, String>> devices = new ArrayList<>();

        Map<String, String> device1 = new HashMap<>();
        device1.put("name", "Device 1");
        device1.put("id", "12345");
        devices.add(device1);

        Map<String, String> device2 = new HashMap<>();
        device2.put("name", "Device 2");
        device2.put("id", "67890");
        devices.add(device2);


        return devices;
    }

}
