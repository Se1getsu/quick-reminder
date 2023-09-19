# quick-reminder
Cocoa MVC アーキテクチャの実践として作成した、個人開発アプリ「クイックリマインダー」です。
リリースはしていません。以下はアプリの概要。

- 決まった時間にプッシュ通知を行うリマインダーアプリ。
- 通知時刻を指定すると、次その時刻になるタイミングに通知が行われる。
  - 翌日の現在までの範囲で設定可能。
- 通知済みのリマインダーは灰色で表示され、12時間後には自動的に削除される。

# Installation
```bash
$ git clone https://github.com/Se1getsu/quick-reminder.git
$ cd quick-reminder/
$ pod install
```
Xcode上に赤文字で表示される `R.generated.swift` はビルド時に自動生成されます。
