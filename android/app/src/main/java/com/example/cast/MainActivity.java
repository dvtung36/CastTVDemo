package com.example.cast;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.os.Bundle;
import android.os.PersistableBundle;
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
                            if (call.method.equals("get_list_device")) {
                                List<Map<String, String>> devices = getDevices();
                                result.success(devices);
                            } else if (call.method.equals("connect_device")) {
                                String id = call.argument("id");
                                if (id != null) {
                                    connectToDevice(id);
                                    result.success(null);
                                } else {
                                    result.error("INVALID_ARGUMENT", "Value is null", null);
                                }
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

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startDiscovery();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopDiscovery();
    }

    // Bắt đầu quét các thiết bị
    public void startDiscovery() {
        Log.d("2ndScreenAPP", "TungDV startDiscovery");
        DiscoveryManager.init(getApplicationContext());
        mDiscoveryManager = DiscoveryManager.getInstance();
        mDiscoveryManager.registerDefaultDeviceTypes();
        mDiscoveryManager.setPairingLevel(PairingLevel.ON);
        mDiscoveryManager.start();
    }

    // Dừng quét các thiết bị
    public void stopDiscovery() {
        mDiscoveryManager.stop();
    }

    // Kết nối với thiết bị đã chọn
    public void connectToDevice(String id) {
        for (ConnectableDevice device : mDiscoveryManager.getCompatibleDevices().values()) {
            if (Objects.equals(device.getId(), id)) {

                Log.d("2ndScreenAPP", " TungDV Start connect Device " + device.getFriendlyName());
                mTV = device;
                mTV.addListener(deviceListener);
                mTV.setPairingType(PIN_CODE);
                mTV.connect();
            }
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

    public List<ConnectableDevice> getImageDevices() {
        List<ConnectableDevice> imageDevices = new ArrayList<ConnectableDevice>();

        for (ConnectableDevice device : mDiscoveryManager.getCompatibleDevices().values()) {
            if (device.hasCapability(MediaPlayer.Display_Image))
                imageDevices.add(device);
        }

        return imageDevices;
    }

    private List<Map<String, String>> getDevices() {

        Log.d("2ndScreenAPP", "TungDV getDevices  start");
        List<Map<String, String>> devices = new ArrayList<>();

        for (ConnectableDevice device : mDiscoveryManager.getCompatibleDevices().values()) {
            if (device.hasCapability(MediaPlayer.Display_Image)) {
                Map<String, String> deviceMap = new HashMap<>();
                deviceMap.put("name", device.getFriendlyName());
                deviceMap.put("id", device.getId());
                devices.add(deviceMap);
            }
        }

        return devices;
    }

}
