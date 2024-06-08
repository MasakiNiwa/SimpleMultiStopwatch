# Simple Multi Stopwatch

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](https://en.wikipedia.org/wiki/MIT_License)
[![Flutter version](https://img.shields.io/badge/Flutter-3.22.1-blue)](https://flutter.dev/)

## 概要(Overview)
開発中のFlutterプロジェクトです。<br>
複数のシンプルなストップウォッチを同時利用できるアプリを目指しています。<br>
学習時間・作業時間などの把握に使用できます。<br>
<br>
This is a Flutter project under development. <br>
The goal is to create an app that allows users to use multiple simple stopwatches simultaneously.<br>
It can be used to track learning time, work time, etc. <br>

## スクリーンショット(Screenshots)
<img alt="Screenshot01" src="./screenshots/01.png" width="200px">
<img alt="Screenshot02" src="./screenshots/02.png" width="200px">

## インストール方法(Installation Instructions)

### 前提条件(Prerequisites)
Flutter SDKのインストールなど、Flutter開発環境を作成してください<br>
Set up your Flutter development environment, including installing the Flutter SDK.<br>

### 手順(Steps)
(1)リポジトリのクローン(Clone the repository)<br>
git clone https://github.com/MasakiNiwa/SimpleMultiStopwatch.git<br>
<br>
(2)依存関係のインストール(Install dependencies)<br>
cd (Project directory)<br>
flutter pub get<br>
<br>
(3)アプリの実行(Run the app)<br>
flutter run<br>

### 動かせなくなったとき(Troubleshooting)
(1)プロジェクトをきれいにする(Clean the project)<br>
flutter clean<br>
<br>
(2)プロジェクトを再構築(Rebuild the project)<br>
flutter pub get<br>

## 使い方(How to Use)
・アプリ右下の追加ボタンでストップウォッチを追加 <br>
・Add a stopwatch by tapping the "+" button in the bottom right corner of the app. <br>
・右から左へのスワイプでストップウォッチの背景色を選択 <br>
・Swipe a stopwatch from right to left to select the stopwatch background color. <br>
・左から右へのスワイプでストップウォッチを一つ削除 <br>
・Swipe a stopwatch from left to right to delete it. <br>
・アプリ右上の削除ボタンでストップウォッチを全削除 <br>
・Tap the "Delete All" button in the top right corner of the app to delete all stopwatches. <br>
・ストップウォッチを上下に移動して並び替え<br>
・Drag and drop stopwatches to reorder them.<br>
・時間表示部分のタップでストップウォッチを開始/停止 <br>
・Tap the time display area to start/stop the stopwatch. <br>
・リセットボタンでストップウォッチを0に戻す <br>
・Tap the reset button to reset the stopwatch to 0. <br>
・ストップウォッチ右側にストップウォッチの内容をメモ <br>
・Take notes on the stopwatch on the right side of the stopwatch. <br>
・時間表示部分を上下にスワイプで調整画面を表示<br>
(調整画面では、経過時間の調整と、進捗目標時間の設定が可能です)<br>
・Swipe the time display area up or down to display the adjustment screen. <br>
(On the adjustment screen, you can adjust the elapsed time and set the progress target time.)<br>
・アプリを閉じてもストップウォッチの状態は保存されて、再起動時に復元されます。 <br>
(動いていたストップウォッチは、アプリを閉じていた時間も反映して、再起動時に動作を再開します) <br>
・The stopwatch state is saved even when the app is closed and restored when it is restarted. <br>
(Running stopwatches will resume operation upon restart, reflecting the time the app was closed.) <br>

## お願い(Feedback)
ご意見、ご感想、バグ報告など、お気軽にIssuesやDiscussionsまたはメールでお寄せください<br>
masaki28.dev@gmail.com<br>
<br>
Please feel free to share your feedback, thoughts, and bug reports through Issues, Discussions or email.<br>
(I will do my best to respond using AI translation tools.)<br>
masaki28.dev@gmail.com<br>

## About
このアプリはMITライセンスを採用しています。<br>
This app is licensed under the MIT License.<br>
<br>
Flutterとその他パッケージを次のバージョンで使用しています<br>
This app uses Flutter and other packages with the following versions:<br>
・Flutter: 3.22.1 (BSD 3-Clause)<br>
・Shared Preferences: 2.2.3 (BSD 3-Clause)<br>
・Flutter Slidable: 3.1.0 (MIT)<br>
・Flutter Launcher Icons: 0.13.1 (MIT)<br>
・Flutter Markdown: 0.7.1 (BSD 3-Clause)<br>
・Change App Package Name: 1.1.0 (MIT)<br>

## 最後に(Additional Information)
現在Google Play(android)でクローズドテストを実施中です。<br>
詳細はDiscussionsをご覧ください。<br>
<br>
I am currently conducting a closed test on Google Play (Android).<br>
Please see Discussions for more details.<br>
<br>