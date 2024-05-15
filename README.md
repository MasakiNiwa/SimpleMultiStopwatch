# Simple Multi Stopwatch

## 概要(Overview)
開発中のFlutterプロジェクトです。<br>
複数のシンプルなストップウォッチを同時利用できるアプリを目指しています。<br>
This is a Flutter project under development. <br>
The goal is to create an app that allows users to use multiple simple stopwatches simultaneously.<br>

## スクリーンショット(Screenshots)
<img alt="Screenshot" src="./screenshots/01.png" width="200px">

## 使い方(How to Use)
・アプリ右下の追加ボタンでストップウォッチを追加 <br>
・Add a stopwatch by tapping the "+" button in the bottom right corner of the app. <br>
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
・アプリを閉じてもストップウォッチの状態は保存されて、再起動時に復元されます。 <br>
　(動いていたストップウォッチは、アプリを閉じていた時間も反映して、再起動時に動作を再開します) <br>
・The stopwatch state is saved even when the app is closed and restored when it is restarted. <br>
　(Running stopwatches will resume operation upon restart, reflecting the time the app was closed.) <br>

## 把握しているバグ(Known Bugs)
### 頻度は少ないがデバッグ中にアプリが停止する<br>The app may crash during debugging.
_AssertionError('package:flutter/src/rendering/layer.dart':Failed assertion:line 2692 pos 7:'_debugCheckLeaderBeforeFollower(forwardLayers, inverseLayers)':LeaderLayer anchor must come before FollowerLayer in paint order, but the reverse was true.)<br>
<br>
発生開始時期：ReorderableListViewを使用開始した頃から<br>
発生状況：短時間でストップウォッチを連続して激しく動かす操作をおこなったときが多い<br>
現時点の予想１：ReorderableListViewの使い方が論理的におかしい？<br>
現時点の予想２：TextFieldとReorderableListViewが干渉？<br>
Start of occurrence: Around the time ReorderableListView started being used<br>
Occurrence conditions: Often occurs when multiple stopwatches are manipulated quickly in a short period of time<br>
Current hypothesis 1: Is the usage of ReorderableListView logically incorrect?<br>
Current hypothesis 2: Interference between TextField and ReorderableListView?<br>
<br>
★スワイプと並べ替えが同時に発動するようなタイミングで止まる傾向を発見<br>
・DismissedとReorderableListViewの干渉を防ぐ対応を考えてみる<br>
★I have discovered a tendency to stop at a timing when swiping and reordering seem to occur simultaneously.<br>
・I will consider how to deal with the interference between Dismissed and ReorderableListView.<br>

## 現在の取り組み(Current Work)
実機テスト中です<br>
実際に使って改善点を探してみます<br>
Real device testing is in progress.<br>
I will try to find improvement points by actually using it.<br>

## 直近の目標(Next Steps)
(1)まずはバグを取り除く(Fix bugs)<br>
(2)コメントの見直し(Review code comments)<br>

## 今後の目標(Future Goals)
(1)コードを整理しなおす(Refactor code)<br>
(2)デザインを見直す(Redesign)<br>
(3)アプリを公開する(Publish app)<br>

## その他(Additional Notes)
・まだ開発中のため、不具合が含まれていたらすみません<br>
・不具合のご指摘や、アドバイス等ありましたらご教授お願いいたします<br>
・このプロジェクトが誰かの役にたてたら嬉しいです<br>
・This app is still under development and may contain bugs.<br>
・Please feel free to report any bugs or suggestions you have.<br>
・I hope you find this app useful!<br>