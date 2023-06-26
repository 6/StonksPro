# StonksPro

Trying out Swift for the first time. Apple Vision Pro example app built with [SwiftUI](https://developer.apple.com/xcode/swiftui/) + [visionOS SDK](https://developer.apple.com/documentation/visionos/).

It uses [CoinGecko API](https://www.coingecko.com/en/api) for crypto data and [AlphaVantage API](https://www.alphavantage.co/) for stocks data. Both are free but rate limited.

**Features:**
- List most actively traded stocks + top market cap crypto assets.
- View stock/crypto details with 7d timeseries chart.

### Screenshots

<img width="800" alt="Screenshot 2023-06-26 at 13 44 42" src="https://github.com/6/StonksPro/assets/158675/6a745cde-22b6-4b35-9e8e-29988a428871">
<img width="390" alt="Screenshot 2023-06-26 at 13 45 55" src="https://github.com/6/StonksPro/assets/158675/373a476d-1f94-4a76-9826-74fd581d7afc"> <img width="390" alt="Screenshot 2023-06-26 at 14 42 05" src="https://github.com/6/StonksPro/assets/158675/aaebb58d-0963-47fa-bd5c-9a6d8dff8163">

## Setup

```
brew bundle
```

Then open `StonksPro.xcodeproj` in Xcode 15+ and run the app.

Obtain a free AlphaVantage API key from https://www.alphavantage.co/support/#api-key (note: free API key is limited to 5 API calls per minute and 500 calls per day).

