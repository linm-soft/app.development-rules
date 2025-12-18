# API & Network Standards Implementation

> Comprehensive guide for REST API integration, HTTP client configuration, and network security

**Section:** 2.24  
**Priority:** ⚠️ OPTIONAL  
**User Confirmation:** Required before implementation

---

## 🎯 Overview

**Purpose:** Standardize API integration patterns for consistent, secure, and maintainable network communication

**When to Apply:**
- App requires REST API integration
- Backend communication needed
- Third-party API integration
- Network data synchronization

**When to Skip:**
- Offline-only applications
- Local data storage only
- Simple file-based apps

---

## 📋 Core Implementation Standards

### 1. HTTP Client Configuration

#### 1.1 Retrofit Setup
```java
// ApiClient.java - Centralized HTTP client
public class ApiClient {
    private static final String BASE_URL = "https://api.example.com/";
    private static Retrofit retrofit = null;
    
    public static Retrofit getClient() {
        if (retrofit == null) {
            OkHttpClient.Builder httpClient = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .addInterceptor(new AuthInterceptor())
                .addInterceptor(new LoggingInterceptor());
            
            // Add certificate pinning for production
            if (!BuildConfig.DEBUG) {
                CertificatePinner certificatePinner = new CertificatePinner.Builder()
                    .add("api.example.com", "sha256/XXXXXX")
                    .build();
                httpClient.certificatePinner(certificatePinner);
            }
            
            retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .client(httpClient.build())
                .build();
        }
        return retrofit;
    }
}
```

#### 1.2 OkHttp Interceptors
```java
// AuthInterceptor.java - Token management
public class AuthInterceptor implements Interceptor {
    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        Request originalRequest = chain.request();
        
        String token = TokenManager.getAccessToken();
        if (token != null) {
            Request.Builder builder = originalRequest.newBuilder()
                .addHeader("Authorization", "Bearer " + token)
                .addHeader("Content-Type", "application/json");
            
            Request newRequest = builder.build();
            Response response = chain.proceed(newRequest);
            
            // Handle token refresh on 401
            if (response.code() == 401) {
                response.close();
                if (TokenManager.refreshToken()) {
                    token = TokenManager.getAccessToken();
                    Request refreshedRequest = originalRequest.newBuilder()
                        .addHeader("Authorization", "Bearer " + token)
                        .build();
                    return chain.proceed(refreshedRequest);
                }
            }
            return response;
        }
        
        return chain.proceed(originalRequest);
    }
}

// LoggingInterceptor.java - Request/Response logging
public class LoggingInterceptor implements Interceptor {
    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        Request request = chain.request();
        
        if (BuildConfig.DEBUG) {
            LogHelper.d("API", "Request: " + request.url());
            LogHelper.d("API", "Method: " + request.method());
        }
        
        Response response = chain.proceed(request);
        
        if (BuildConfig.DEBUG) {
            LogHelper.d("API", "Response Code: " + response.code());
        }
        
        return response;
    }
}
```

### 2. API Service Interface

#### 2.1 Standard Service Definition
```java
// ApiService.java - REST endpoints
public interface ApiService {
    // GET requests
    @GET("users/{id}")
    Call<ApiResponse<User>> getUser(@Path("id") String userId);
    
    @GET("users")
    Call<ApiResponse<List<User>>> getUsers(
        @Query("page") int page,
        @Query("limit") int limit
    );
    
    // POST requests
    @POST("users")
    Call<ApiResponse<User>> createUser(@Body CreateUserRequest request);
    
    // PUT requests
    @PUT("users/{id}")
    Call<ApiResponse<User>> updateUser(
        @Path("id") String userId,
        @Body UpdateUserRequest request
    );
    
    // DELETE requests
    @DELETE("users/{id}")
    Call<ApiResponse<Void>> deleteUser(@Path("id") String userId);
    
    // File upload
    @Multipart
    @POST("upload")
    Call<ApiResponse<UploadResponse>> uploadFile(
        @Part MultipartBody.Part file,
        @Part("description") RequestBody description
    );
}
```

### 3. Response Models & Error Handling

#### 3.1 Standardized Response Wrapper
```java
// ApiResponse.java - Generic response wrapper
public class ApiResponse<T> {
    @SerializedName("success")
    private boolean success;
    
    @SerializedName("data")
    private T data;
    
    @SerializedName("message")
    private String message;
    
    @SerializedName("error_code")
    private String errorCode;
    
    @SerializedName("timestamp")
    private String timestamp;
    
    // Getters and setters
    public boolean isSuccess() { return success; }
    public T getData() { return data; }
    public String getMessage() { return message; }
    public String getErrorCode() { return errorCode; }
    public String getTimestamp() { return timestamp; }
}

// ApiError.java - Error response model
public class ApiError {
    private String message;
    private String errorCode;
    private int statusCode;
    
    public ApiError(String message, String errorCode, int statusCode) {
        this.message = message;
        this.errorCode = errorCode;
        this.statusCode = statusCode;
    }
    
    // Getters
    public String getMessage() { return message; }
    public String getErrorCode() { return errorCode; }
    public int getStatusCode() { return statusCode; }
}
```

#### 3.2 Centralized Error Handler
```java
// ApiErrorHandler.java - Centralized error processing
public class ApiErrorHandler {
    
    public static ApiError handleError(Response<?> response) {
        String errorMessage = "Unknown error occurred";
        String errorCode = "UNKNOWN";
        int statusCode = response.code();
        
        try {
            if (response.errorBody() != null) {
                String errorBodyString = response.errorBody().string();
                
                // Try to parse error response
                Gson gson = new Gson();
                ApiResponse<?> errorResponse = gson.fromJson(errorBodyString, ApiResponse.class);
                
                if (errorResponse != null) {
                    errorMessage = errorResponse.getMessage();
                    errorCode = errorResponse.getErrorCode();
                }
            }
        } catch (IOException | JsonSyntaxException e) {
            LogHelper.e("API", "Error parsing error response", e);
        }
        
        // Map HTTP status codes to user-friendly messages
        switch (statusCode) {
            case 400:
                errorMessage = "Invalid request. Please check your input.";
                break;
            case 401:
                errorMessage = "Authentication required. Please log in again.";
                break;
            case 403:
                errorMessage = "Access denied. You don't have permission.";
                break;
            case 404:
                errorMessage = "Requested resource not found.";
                break;
            case 429:
                errorMessage = "Too many requests. Please try again later.";
                break;
            case 500:
            case 502:
            case 503:
                errorMessage = "Server error. Please try again later.";
                break;
            default:
                if (statusCode >= 500) {
                    errorMessage = "Server error occurred.";
                } else if (statusCode >= 400) {
                    errorMessage = "Client error occurred.";
                }
                break;
        }
        
        return new ApiError(errorMessage, errorCode, statusCode);
    }
    
    public static ApiError handleException(Throwable throwable) {
        String errorMessage;
        String errorCode = "NETWORK_ERROR";
        
        if (throwable instanceof IOException) {
            errorMessage = "Network connection failed. Please check your internet.";
        } else if (throwable instanceof JsonSyntaxException) {
            errorMessage = "Data format error. Please try again.";
            errorCode = "PARSE_ERROR";
        } else {
            errorMessage = "Unexpected error occurred. Please try again.";
            errorCode = "UNEXPECTED_ERROR";
        }
        
        LogHelper.e("API", "Network error: " + errorMessage, throwable);
        return new ApiError(errorMessage, errorCode, 0);
    }
}
```

### 4. Repository Pattern Implementation

#### 4.1 Repository Base Class
```java
// BaseRepository.java - Common repository functionality
public abstract class BaseRepository {
    protected ApiService apiService;
    protected Context context;
    
    public BaseRepository(Context context) {
        this.context = context;
        this.apiService = ApiClient.getClient().create(ApiService.class);
    }
    
    protected <T> void executeCall(Call<ApiResponse<T>> call, ApiCallback<T> callback) {
        if (!NetworkUtils.isNetworkAvailable(context)) {
            callback.onError(new ApiError("No internet connection", "NO_NETWORK", 0));
            return;
        }
        
        call.enqueue(new Callback<ApiResponse<T>>() {
            @Override
            public void onResponse(@NonNull Call<ApiResponse<T>> call, 
                                 @NonNull Response<ApiResponse<T>> response) {
                if (response.isSuccessful() && response.body() != null) {
                    ApiResponse<T> apiResponse = response.body();
                    if (apiResponse.isSuccess()) {
                        callback.onSuccess(apiResponse.getData());
                    } else {
                        callback.onError(new ApiError(
                            apiResponse.getMessage(),
                            apiResponse.getErrorCode(),
                            response.code()
                        ));
                    }
                } else {
                    ApiError error = ApiErrorHandler.handleError(response);
                    callback.onError(error);
                }
            }
            
            @Override
            public void onFailure(@NonNull Call<ApiResponse<T>> call, @NonNull Throwable t) {
                ApiError error = ApiErrorHandler.handleException(t);
                callback.onError(error);
            }
        });
    }
}

// ApiCallback.java - Standard callback interface
public interface ApiCallback<T> {
    void onSuccess(T data);
    void onError(ApiError error);
}
```

#### 4.2 Specific Repository Implementation
```java
// UserRepository.java - Example repository
public class UserRepository extends BaseRepository {
    
    public UserRepository(Context context) {
        super(context);
    }
    
    public void getUser(String userId, ApiCallback<User> callback) {
        Call<ApiResponse<User>> call = apiService.getUser(userId);
        executeCall(call, callback);
    }
    
    public void createUser(CreateUserRequest request, ApiCallback<User> callback) {
        Call<ApiResponse<User>> call = apiService.createUser(request);
        executeCall(call, callback);
    }
    
    public void getUsers(int page, int limit, ApiCallback<List<User>> callback) {
        Call<ApiResponse<List<User>>> call = apiService.getUsers(page, limit);
        executeCall(call, callback);
    }
}
```

### 5. Token Management

#### 5.1 Secure Token Storage
```java
// TokenManager.java - Secure token handling
public class TokenManager {
    private static final String PREF_NAME = "auth_tokens";
    private static final String KEY_ACCESS_TOKEN = "access_token";
    private static final String KEY_REFRESH_TOKEN = "refresh_token";
    private static final String KEY_TOKEN_EXPIRY = "token_expiry";
    
    private static SharedPreferences getPreferences(Context context) {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
    }
    
    public static void saveTokens(Context context, String accessToken, 
                                 String refreshToken, long expiryTime) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        editor.putString(KEY_ACCESS_TOKEN, accessToken);
        editor.putString(KEY_REFRESH_TOKEN, refreshToken);
        editor.putLong(KEY_TOKEN_EXPIRY, expiryTime);
        editor.apply();
    }
    
    public static String getAccessToken(Context context) {
        SharedPreferences prefs = getPreferences(context);
        String token = prefs.getString(KEY_ACCESS_TOKEN, null);
        long expiry = prefs.getLong(KEY_TOKEN_EXPIRY, 0);
        
        if (token != null && System.currentTimeMillis() < expiry) {
            return token;
        }
        return null;
    }
    
    public static String getRefreshToken(Context context) {
        return getPreferences(context).getString(KEY_REFRESH_TOKEN, null);
    }
    
    public static boolean refreshToken(Context context) {
        String refreshToken = getRefreshToken(context);
        if (refreshToken == null) {
            return false;
        }
        
        try {
            // Synchronous refresh token call
            Call<ApiResponse<TokenResponse>> call = ApiClient.getClient()
                .create(ApiService.class)
                .refreshToken(new RefreshTokenRequest(refreshToken));
            
            Response<ApiResponse<TokenResponse>> response = call.execute();
            
            if (response.isSuccessful() && response.body() != null) {
                ApiResponse<TokenResponse> apiResponse = response.body();
                if (apiResponse.isSuccess()) {
                    TokenResponse tokenResponse = apiResponse.getData();
                    saveTokens(context,
                        tokenResponse.getAccessToken(),
                        tokenResponse.getRefreshToken(),
                        tokenResponse.getExpiryTime()
                    );
                    return true;
                }
            }
        } catch (IOException e) {
            LogHelper.e("TokenManager", "Failed to refresh token", e);
        }
        
        // Clear invalid tokens
        clearTokens(context);
        return false;
    }
    
    public static void clearTokens(Context context) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        editor.clear();
        editor.apply();
    }
}
```

### 6. Network Utilities

#### 6.1 Network State Management
```java
// NetworkUtils.java - Network connectivity utilities
public class NetworkUtils {
    
    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager connectivityManager = 
            (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        
        if (connectivityManager == null) {
            return false;
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkCapabilities capabilities = connectivityManager
                .getNetworkCapabilities(connectivityManager.getActiveNetwork());
            return capabilities != null && 
                   (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET));
        } else {
            NetworkInfo activeNetwork = connectivityManager.getActiveNetworkInfo();
            return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
        }
    }
    
    public static boolean isWifiConnected(Context context) {
        ConnectivityManager connectivityManager = 
            (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        
        if (connectivityManager == null) {
            return false;
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkCapabilities capabilities = connectivityManager
                .getNetworkCapabilities(connectivityManager.getActiveNetwork());
            return capabilities != null && 
                   capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI);
        } else {
            NetworkInfo wifiNetwork = connectivityManager
                .getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            return wifiNetwork != null && wifiNetwork.isConnected();
        }
    }
}

// NetworkStateReceiver.java - Monitor network changes
public class NetworkStateReceiver extends BroadcastReceiver {
    private NetworkStateListener listener;
    
    public NetworkStateReceiver(NetworkStateListener listener) {
        this.listener = listener;
    }
    
    @Override
    public void onReceive(Context context, Intent intent) {
        if (listener != null) {
            boolean isConnected = NetworkUtils.isNetworkAvailable(context);
            listener.onNetworkStateChanged(isConnected);
        }
    }
    
    public interface NetworkStateListener {
        void onNetworkStateChanged(boolean isConnected);
    }
}
```

### 7. Request/Response Models

#### 7.1 Standard Request Models
```java
// CreateUserRequest.java - Example request model
public class CreateUserRequest {
    @SerializedName("username")
    private String username;
    
    @SerializedName("email")
    private String email;
    
    @SerializedName("password")
    private String password;
    
    @SerializedName("profile")
    private UserProfile profile;
    
    public CreateUserRequest(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }
    
    // Getters and setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public UserProfile getProfile() { return profile; }
    public void setProfile(UserProfile profile) { this.profile = profile; }
}

// RefreshTokenRequest.java - Token refresh model
public class RefreshTokenRequest {
    @SerializedName("refresh_token")
    private String refreshToken;
    
    public RefreshTokenRequest(String refreshToken) {
        this.refreshToken = refreshToken;
    }
    
    public String getRefreshToken() { return refreshToken; }
}
```

#### 7.2 Response Models
```java
// User.java - Example response model
public class User {
    @SerializedName("id")
    private String id;
    
    @SerializedName("username")
    private String username;
    
    @SerializedName("email")
    private String email;
    
    @SerializedName("profile")
    private UserProfile profile;
    
    @SerializedName("created_at")
    private String createdAt;
    
    @SerializedName("updated_at")
    private String updatedAt;
    
    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public UserProfile getProfile() { return profile; }
    public void setProfile(UserProfile profile) { this.profile = profile; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
}

// TokenResponse.java - Authentication response
public class TokenResponse {
    @SerializedName("access_token")
    private String accessToken;
    
    @SerializedName("refresh_token")
    private String refreshToken;
    
    @SerializedName("token_type")
    private String tokenType;
    
    @SerializedName("expires_in")
    private long expiresIn;
    
    public String getAccessToken() { return accessToken; }
    public String getRefreshToken() { return refreshToken; }
    public String getTokenType() { return tokenType; }
    public long getExpiresIn() { return expiresIn; }
    
    public long getExpiryTime() {
        return System.currentTimeMillis() + (expiresIn * 1000);
    }
}
```

---

## 🔒 Security Best Practices

### 1. Certificate Pinning
```java
// Production certificate pinning
CertificatePinner certificatePinner = new CertificatePinner.Builder()
    .add("api.yourapp.com", "sha256/PRIMARY_CERTIFICATE_HASH")
    .add("api.yourapp.com", "sha256/BACKUP_CERTIFICATE_HASH")
    .build();
```

### 2. Request/Response Encryption
```java
// Add encryption interceptor for sensitive data
public class EncryptionInterceptor implements Interceptor {
    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        Request request = chain.request();
        
        // Encrypt request body for sensitive endpoints
        if (needsEncryption(request.url().toString())) {
            RequestBody originalBody = request.body();
            if (originalBody != null) {
                String encryptedBody = EncryptionUtils.encrypt(bodyToString(originalBody));
                RequestBody newBody = RequestBody.create(
                    MediaType.parse("application/json"),
                    encryptedBody
                );
                request = request.newBuilder()
                    .method(request.method(), newBody)
                    .build();
            }
        }
        
        Response response = chain.proceed(request);
        
        // Decrypt response body if needed
        if (needsDecryption(response)) {
            String responseBody = response.body().string();
            String decryptedBody = EncryptionUtils.decrypt(responseBody);
            
            ResponseBody newResponseBody = ResponseBody.create(
                response.body().contentType(),
                decryptedBody
            );
            
            response = response.newBuilder()
                .body(newResponseBody)
                .build();
        }
        
        return response;
    }
}
```

### 3. Request Validation
```java
// Validate requests before sending
public class RequestValidator {
    
    public static boolean validateCreateUser(CreateUserRequest request) {
        if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
            return false;
        }
        
        if (request.getEmail() == null || !isValidEmail(request.getEmail())) {
            return false;
        }
        
        if (request.getPassword() == null || request.getPassword().length() < 8) {
            return false;
        }
        
        return true;
    }
    
    private static boolean isValidEmail(String email) {
        return email.contains("@") && email.contains(".");
    }
}
```

---

## 📱 Activity/Fragment Integration

### 1. Repository Usage in Activities
```java
// MainActivity.java - Repository integration example
public class MainActivity extends AppCompatActivity {
    private UserRepository userRepository;
    private ProgressDialog progressDialog;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        userRepository = new UserRepository(this);
        setupUI();
    }
    
    private void loadUser(String userId) {
        showProgress("Loading user...");
        
        userRepository.getUser(userId, new ApiCallback<User>() {
            @Override
            public void onSuccess(User user) {
                hideProgress();
                displayUser(user);
            }
            
            @Override
            public void onError(ApiError error) {
                hideProgress();
                showErrorDialog(error.getMessage());
            }
        });
    }
    
    private void showProgress(String message) {
        progressDialog = ProgressDialog.show(this, null, message, true);
    }
    
    private void hideProgress() {
        if (progressDialog != null && progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
    }
    
    private void showErrorDialog(String message) {
        new AlertDialog.Builder(this)
            .setTitle("Error")
            .setMessage(message)
            .setPositiveButton("OK", null)
            .show();
    }
}
```

### 2. Loading States Management
```java
// LoadingStateManager.java - Centralized loading states
public class LoadingStateManager {
    private ProgressDialog progressDialog;
    private Context context;
    
    public LoadingStateManager(Context context) {
        this.context = context;
    }
    
    public void showLoading(String message) {
        hideLoading(); // Ensure no duplicate dialogs
        progressDialog = ProgressDialog.show(context, null, message, true);
    }
    
    public void hideLoading() {
        if (progressDialog != null && progressDialog.isShowing()) {
            progressDialog.dismiss();
            progressDialog = null;
        }
    }
    
    public void showError(String message, String title) {
        hideLoading();
        new AlertDialog.Builder(context)
            .setTitle(title != null ? title : "Error")
            .setMessage(message)
            .setPositiveButton("OK", null)
            .show();
    }
    
    public void showSuccess(String message) {
        hideLoading();
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }
}
```

---

## 🏗️ Project Structure

### Recommended Package Structure
```
com.yourapp.network/
├── api/
│   ├── ApiClient.java
│   ├── ApiService.java
│   └── interceptors/
│       ├── AuthInterceptor.java
│       ├── LoggingInterceptor.java
│       └── EncryptionInterceptor.java
├── models/
│   ├── request/
│   │   ├── CreateUserRequest.java
│   │   ├── UpdateUserRequest.java
│   │   └── RefreshTokenRequest.java
│   ├── response/
│   │   ├── ApiResponse.java
│   │   ├── User.java
│   │   ├── TokenResponse.java
│   │   └── UploadResponse.java
│   └── error/
│       └── ApiError.java
├── repository/
│   ├── BaseRepository.java
│   ├── UserRepository.java
│   └── AuthRepository.java
├── utils/
│   ├── NetworkUtils.java
│   ├── TokenManager.java
│   ├── ApiErrorHandler.java
│   └── RequestValidator.java
└── callback/
    └── ApiCallback.java
```

---

## 📋 Dependencies

### Add to build.gradle (app)
```gradle
dependencies {
    // Retrofit for REST API
    implementation 'com.squareup.retrofit2:retrofit:2.9.0'
    implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
    
    // OkHttp for HTTP client
    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
    implementation 'com.squareup.okhttp3:logging-interceptor:4.12.0'
    
    // Gson for JSON parsing
    implementation 'com.google.code.gson:gson:2.10.1'
    
    // Network permissions in AndroidManifest.xml
}
```

### Add to AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- Optional: For certificate pinning -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />

<!-- Network security config -->
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ... >
</application>
```

### Network Security Config (res/xml/network_security_config.xml)
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config>
        <domain includeSubdomains="true">api.yourapp.com</domain>
        <pin-set expiration="2024-12-31">
            <pin digest="SHA-256">PRIMARY_CERTIFICATE_HASH</pin>
            <pin digest="SHA-256">BACKUP_CERTIFICATE_HASH</pin>
        </pin-set>
    </domain-config>
    
    <!-- Allow HTTP for debug builds only -->
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">api-dev.yourapp.com</domain>
    </domain-config>
</network-security-config>
```

---

## ✅ Implementation Checklist

### Pre-Implementation
- [ ] User confirmed need for API integration
- [ ] Backend API endpoints documented
- [ ] Authentication method defined
- [ ] Security requirements identified

### Core Setup
- [ ] Add Retrofit & OkHttp dependencies
- [ ] Create ApiClient with centralized configuration
- [ ] Implement ApiService interface
- [ ] Setup interceptors (Auth, Logging)
- [ ] Add network permissions to manifest

### Models & Response Handling
- [ ] Create standardized ApiResponse wrapper
- [ ] Implement request/response models
- [ ] Setup ApiError and error handling
- [ ] Create ApiErrorHandler utility

### Repository Pattern
- [ ] Implement BaseRepository
- [ ] Create specific repositories for each API module
- [ ] Setup ApiCallback interface
- [ ] Add network state checking

### Security
- [ ] Implement TokenManager for secure storage
- [ ] Add certificate pinning for production
- [ ] Setup request/response validation
- [ ] Configure network security config

### Integration
- [ ] Integrate repositories in Activities/Fragments
- [ ] Implement loading states management
- [ ] Add proper error handling UI
- [ ] Test network connectivity scenarios

### Testing
- [ ] Test API calls with mock server
- [ ] Verify error handling scenarios
- [ ] Test token refresh mechanism
- [ ] Validate offline behavior

---

## 📝 Summary

This implementation provides:

✅ **Standardized HTTP client** with Retrofit + OkHttp  
✅ **Centralized error handling** with user-friendly messages  
✅ **Secure token management** with automatic refresh  
✅ **Repository pattern** for clean architecture  
✅ **Network security** with certificate pinning  
✅ **Comprehensive logging** integrated with LogHelper  
✅ **Loading states management** for better UX  
✅ **Request/response validation** for data integrity  

**User Confirmation Required:** Always ask before implementing API integration standards as this is an optional feature that depends on app requirements.