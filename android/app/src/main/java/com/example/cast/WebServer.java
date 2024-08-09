package com.example.cast;

import fi.iki.elonen.NanoHTTPD;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import android.util.Log;

public class WebServer extends NanoHTTPD {

    private static final String TAG = "MyHttpServer";
    private File imageFile;

    public WebServer()  {
        super(8080); // Khởi tạo máy chủ với cổng 8080

    }

    public void SetImageFile(File imgFile) {
        this.imageFile = imgFile;
    }

    @Override
    public Response serve(IHTTPSession session) {

        String uri = session.getUri();

        try {
            InputStream inputStream = new FileInputStream(imageFile);
            return newFixedLengthResponse(Response.Status.OK, "image/jpeg", inputStream, imageFile.length());
        } catch (IOException e) {
            Log.e(TAG, "Error serving image", e);
            return newFixedLengthResponse(Response.Status.INTERNAL_ERROR, "text/plain", "Error serving image");
        }

    }

    public void startServer() {
        try {
            start();
            Log.i(TAG, "Server started on port 8080");
        } catch (IOException e) {
            Log.e(TAG, "Failed to start server", e);
        }
    }

    public void stopServer() {
        stop();
        Log.i(TAG, "Server stopped");
    }
}
