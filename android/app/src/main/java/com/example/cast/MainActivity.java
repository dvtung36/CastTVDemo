package com.example.cast;


import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "unisoft_cast_tv";

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
