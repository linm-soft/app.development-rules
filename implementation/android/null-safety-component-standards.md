# Null Safety Component Standards

[← Back to Implementation](../null-safety-standards.md)

## ⚙️ JAVA IMPLEMENTATION

### 1. External Dependency Protection Patterns

#### A. Media Player Protection (ExoPlayer, MediaPlayer)
```java
// ✅ MANDATORY PATTERN - Media Player Protection
public void loadPlaylist(List<NewsArticle> articles, int startIndex) {
    if (player == null) {
        LogHelper.e(TAG, "Player is null in loadPlaylist, reinitializing...");
        initializePlayer();
        if (player == null) {
            LogHelper.e(TAG, "Failed to reinitialize player in loadPlaylist");
            if (playerStateListener != null) {
                playerStateListener.onPlayerError();
            }
            return;
        }
    }
    
    // Validate input parameters
    if (articles == null || articles.isEmpty()) {
        LogHelper.e(TAG, "No valid articles in playlist");
        if (playerStateListener != null) {
            playerStateListener.onPlayerError();
        }
        return;
    }
    
    List<MediaItem> mediaItems = new ArrayList<>();
    for (NewsArticle article : articles) {
        if (article == null || article.getAudioUrl() == null) {
            LogHelper.w(TAG, "Skipping invalid article in playlist");
            continue;
        }
        
        Uri uri = (article.isDownloaded() && article.getLocalAudioPath() != null)
                ? Uri.parse(article.getLocalAudioPath())
                : Uri.parse(article.getAudioUrl());
        
        MediaItem mediaItem = new MediaItem.Builder()
                .setUri(uri)
                .setMediaId(String.valueOf(article.getId()))
                .setTag(article)
                .build();
        mediaItems.add(mediaItem);
    }

    if (mediaItems.isEmpty()) {
        LogHelper.e(TAG, "No valid media items in playlist");
        if (playerStateListener != null) {
            playerStateListener.onPlayerError();
        }
        return;
    }

    player.setMediaItems(mediaItems, startIndex, 0);
    player.prepare();
    player.play();
    
    // Update current article immediately
    if (startIndex >= 0 && startIndex < articles.size()) {
        this.currentArticle = articles.get(startIndex);
        if (notificationManager != null) {
            notificationManager.invalidate();
        }
    }
}

// ✅ MANDATORY PATTERN - Single Article Loading
public void loadArticle(NewsArticle article, long userId) {
    if (article == null || article.getAudioUrl() == null) {
        LogHelper.e(TAG, "Invalid article or audio URL");
        if (playerStateListener != null) {
            playerStateListener.onPlayerError();
        }
        return;
    }
    
    if (player == null) {
        LogHelper.e(TAG, "Player is null in loadArticle, reinitializing...");
        initializePlayer();
        if (player == null) {
            LogHelper.e(TAG, "Failed to reinitialize player in loadArticle");
            if (playerStateListener != null) {
                playerStateListener.onPlayerError();
            }
            return;
        }
    }
    
    // Reset error state when starting fresh playback
    if (!errorHandler.isRetrying()) {
        errorHandler.resetArticleErrorState(article);
    }
    
    this.currentArticle = article;
    this.currentUserId = userId;
    
    // Update notification
    if (notificationManager != null) {
        notificationManager.invalidate();
    }
    
    // Get playback URL with fallback support
    String audioUrl = article.getPlaybackUrlWithFallback();
    LogHelper.d(TAG, "Loading audio URL: " + audioUrl);
    
    MediaItem mediaItem = MediaItem.fromUri(Uri.parse(audioUrl));
    player.setMediaItem(mediaItem);
    player.prepare();
    
    // Restore previous progress
    UserNewsProgress progress = newsDb.getUserNewsProgress(userId, article.getId());
    if (progress != null && progress.getCurrentPosition() > 0) {
        player.seekTo(progress.getCurrentPosition());
    }
    
    // Increment play count
    newsDb.incrementPlayCount(article.getId());
    
    LogHelper.d(TAG, "Loaded article: " + article.getTitle());
}
```

#### B. Database Connection Protection
```java
// ✅ MANDATORY PATTERN - Database Protection
public void saveUserProgress(int articleId, long position) {
    if (database == null) {
        LogHelper.e(TAG, "Database null, attempting reconnection...");
        initializeDatabase();
        if (database == null) {
            LogHelper.e(TAG, "Failed to reconnect database");
            showUserErrorMessage("Database temporarily unavailable");
            return;
        }
    }
    
    // Validate parameters
    if (articleId <= 0) {
        LogHelper.w(TAG, "Invalid article ID: " + articleId);
        return;
    }
    
    if (position < 0) {
        LogHelper.w(TAG, "Invalid position: " + position + ", using 0");
        position = 0;
    }
    
    // Protected database operations
    try {
        database.updateProgress(articleId, position);
        LogHelper.d(TAG, "Progress saved: article=" + articleId + ", position=" + position);
    } catch (Exception e) {
        LogHelper.e(TAG, "Failed to save progress", e);
        showUserErrorMessage("Failed to save progress");
    }
}
```

#### C. Context Protection in Fragments/Services
```java
// ✅ MANDATORY PATTERN - Context Protection
public void showToast(String message) {
    if (getContext() == null) {
        LogHelper.w(TAG, "Context null, cannot show toast: " + message);
        return;
    }
    
    if (message == null || message.isEmpty()) {
        LogHelper.w(TAG, "Empty toast message");
        return;
    }
    
    Toast.makeText(getContext(), message, Toast.LENGTH_SHORT).show();
}

// ✅ SAFE UI UPDATE PATTERN
public void updateUI() {
    if (!isAdded() || getContext() == null) {
        LogHelper.w(TAG, "Fragment not attached, skipping UI update");
        return;
    }
    
    // Safe to update UI
    if (getActivity() != null) {
        getActivity().runOnUiThread(() -> {
            // UI update code here
            if (isAdded() && getView() != null) {
                // Perform UI updates
            }
        });
    }
}
```

### 2. Auto-Recovery Mechanisms

#### A. Component Reinitialization Pattern
```java
// ✅ STANDARD AUTO-RECOVERY PATTERN
private boolean ensurePlayerInitialized() {
    if (player == null) {
        LogHelper.w(TAG, "Player null, attempting auto-recovery...");
        initializePlayer();
        
        if (player == null) {
            LogHelper.e(TAG, "Auto-recovery failed for player");
            return false;
        }
        
        LogHelper.i(TAG, "Player auto-recovery successful");
    }
    return true;
}

// Usage in playback methods
public void play() {
    if (!ensurePlayerInitialized()) {
        handlePlayerUnavailable();
        return;
    }
    
    if (currentArticle == null) {
        LogHelper.w(TAG, "No current article to play");
        return;
    }
    
    player.play();
    LogHelper.d(TAG, "Playing: " + currentArticle.getTitle());
}

public void pause() {
    if (player != null && player.isPlaying()) {
        player.pause();
        saveProgress();
        LogHelper.d(TAG, "Paused");
    } else {
        LogHelper.w(TAG, "Cannot pause: player null or not playing");
    }
}
```

#### B. Service Connection Auto-Recovery
```java
// ✅ SERVICE CONNECTION PATTERN
private boolean ensureServiceConnected() {
    if (downloadService == null) {
        LogHelper.w(TAG, "Service disconnected, attempting reconnection...");
        bindDownloadService();
        
        if (downloadService == null) {
            LogHelper.e(TAG, "Service reconnection failed");
            return false;
        }
    }
    return true;
}

private ServiceConnection serviceConnection = new ServiceConnection() {
    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
        LogHelper.i(TAG, "Service connected successfully");
        downloadService = ((DownloadService.LocalBinder) service).getService();
        
        // Notify waiting operations
        if (pendingDownloads != null && !pendingDownloads.isEmpty()) {
            processPendingDownloads();
        }
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
        LogHelper.w(TAG, "Service disconnected unexpectedly");
        downloadService = null;
        
        // Handle graceful degradation
        showServiceUnavailableMessage();
    }
};
```

### 3. Input Validation Standards

#### A. Method Parameter Validation
```java
// ✅ MANDATORY INPUT VALIDATION
public void loadArticle(NewsArticle article, long userId) {
    // Validate all inputs
    if (article == null) {
        LogHelper.e(TAG, "Cannot load null article");
        if (errorCallback != null) {
            errorCallback.onError("Invalid article data");
        }
        return;
    }
    
    if (article.getAudioUrl() == null || article.getAudioUrl().isEmpty()) {
        LogHelper.e(TAG, "Article missing audio URL: " + article.getTitle());
        if (errorCallback != null) {
            errorCallback.onError("Article has no audio content");
        }
        return;
    }
    
    if (userId <= 0) {
        LogHelper.w(TAG, "Invalid user ID: " + userId + ", using default");
        userId = 1; // Fallback to default user
    }
    
    // Continue with validated inputs
    loadArticleInternal(article, userId);
}
```

#### B. Collection Validation
```java
// ✅ COLLECTION VALIDATION PATTERN
public void updatePlaylist(List<NewsArticle> articles) {
    if (articles == null) {
        LogHelper.w(TAG, "Null playlist provided, using empty list");
        articles = new ArrayList<>();
    }
    
    // Remove null items
    List<NewsArticle> validArticles = new ArrayList<>();
    for (NewsArticle article : articles) {
        if (article != null && article.getAudioUrl() != null) {
            validArticles.add(article);
        } else {
            LogHelper.w(TAG, "Skipping invalid article in playlist");
        }
    }
    
    if (validArticles.isEmpty()) {
        LogHelper.w(TAG, "No valid articles in playlist");
        showEmptyPlaylistMessage();
        return;
    }
    
    // Process valid articles
    processValidPlaylist(validArticles);
}
```

### 4. Graceful Degradation Patterns

#### A. User-Friendly Error Messages
```java
// ✅ GRACEFUL ERROR HANDLING
private void handlePlayerUnavailable() {
    LogHelper.e(TAG, "Player unavailable, showing user message");
    
    if (getContext() != null) {
        Toast.makeText(getContext(), 
            getString(R.string.audio_player_temporarily_unavailable), 
            Toast.LENGTH_LONG).show();
    }
    
    // Disable player-related UI
    if (playButton != null) {
        playButton.setEnabled(false);
        playButton.setText(R.string.audio_unavailable);
    }
    
    // Attempt background recovery
    schedulePlayerRecovery();
}

private void schedulePlayerRecovery() {
    Handler handler = new Handler(Looper.getMainLooper());
    handler.postDelayed(() -> {
        if (ensurePlayerInitialized()) {
            // Re-enable UI on successful recovery
            if (playButton != null) {
                playButton.setEnabled(true);
                playButton.setText(R.string.play);
            }
            LogHelper.i(TAG, "Player recovery completed");
        }
    }, 3000); // Retry after 3 seconds
}
```

#### B. Fallback Data Sources
```java
// ✅ FALLBACK MECHANISM
public String getArticleContent(NewsArticle article) {
    if (article == null) {
        LogHelper.w(TAG, "Null article, returning placeholder content");
        return getString(R.string.content_not_available);
    }
    
    // Try primary content
    if (article.getContent() != null && !article.getContent().isEmpty()) {
        return article.getContent();
    }
    
    // Try summary as fallback
    if (article.getSummary() != null && !article.getSummary().isEmpty()) {
        LogHelper.i(TAG, "Using summary as content fallback");
        return article.getSummary();
    }
    
    // Try description as last resort
    if (article.getDescription() != null && !article.getDescription().isEmpty()) {
        LogHelper.i(TAG, "Using description as content fallback");
        return article.getDescription();
    }
    
    // Final fallback
    LogHelper.w(TAG, "No content available for article: " + article.getTitle());
    return getString(R.string.content_not_available);
}
```

### 5. Lifecycle Protection Patterns

#### A. Fragment Lifecycle Protection
```java
// ✅ FRAGMENT LIFECYCLE PROTECTION
@Override
public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    
    // Validate fragment is still attached
    if (!isAdded() || getContext() == null) {
        LogHelper.w(TAG, "Fragment not properly attached, skipping view setup");
        return;
    }
    
    setupViews();
}

@Override
public void onResume() {
    super.onResume();
    
    // Check if components need reinitialization
    if (audioPlayer == null && getContext() != null) {
        LogHelper.i(TAG, "Reinitializing audio player on resume");
        audioPlayer = NewsAudioPlayer.getInstance(getContext());
    }
}

@Override
public void onDestroy() {
    // Proper cleanup to prevent memory leaks
    if (audioPlayer != null) {
        audioPlayer.setPlayerStateListener(null);
        audioPlayer.release();
        audioPlayer = null;
    }
    
    if (serviceConnection != null) {
        try {
            getContext().unbindService(serviceConnection);
        } catch (Exception e) {
            LogHelper.w(TAG, "Service was not bound");
        }
    }
    
    super.onDestroy();
}
```

## 📋 STRING RESOURCES

```xml
<!-- res/values/strings.xml -->
<string name="audio_player_temporarily_unavailable">Audio player is temporarily unavailable. Please try again.</string>
<string name="audio_unavailable">Audio Unavailable</string>
<string name="content_not_available">Content not available</string>
<string name="database_temporarily_unavailable">Database temporarily unavailable</string>
<string name="service_unavailable">Service temporarily unavailable</string>
<string name="failed_to_save_progress">Failed to save progress</string>
```

## 🎯 INTEGRATION USAGE

### Using in NewsAudioPlayer Service
```java
public class NewsAudioPlayer {
    private static final String TAG = "NewsAudioPlayer";
    
    // Apply all protection patterns from above
    public void loadPlaylist(List<NewsArticle> articles, int startIndex) {
        // Use Media Player Protection pattern
    }
    
    public void loadArticle(NewsArticle article, long userId) {
        // Use Single Article Loading pattern
    }
}
```

### Using in Fragment Classes
```java
public class MainNews extends Fragment {
    private static final String TAG = "MainNews";
    
    // Apply Fragment Lifecycle Protection
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        // Use Fragment Lifecycle Protection pattern
    }
    
    private void playArticle(NewsArticle article) {
        try {
            if (audioPlayer != null && article != null) {
                // Use Input Validation patterns
                audioPlayer.loadArticle(article, getCurrentUserId());
            }
        } catch (Exception e) {
            LogHelper.e(TAG, "Failed to play article", e);
            if (getContext() != null) {
                Toast.makeText(getContext(), R.string.error_occurred, Toast.LENGTH_SHORT).show();
            }
        }
    }
}
```

**📂 Note**: This implementation uses design standards from:
- [Error Handling](../error-handling.md) for crash prevention strategies
- [Comprehensive Logging System](../comprehensive-logging-system.md) for debug logging patterns