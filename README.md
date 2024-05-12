# Simple Multi Stopwatch

## 概要(Overview)
開発中のFlutterプロジェクトです。<br>
複数のシンプルなストップウォッチを同時利用できるアプリを目指しています。<br>
This is a Flutter project under development. <br>
The goal is to create an app that allows users to use multiple simple stopwatches simultaneously.<br>

## 使い方(How to Use)
・アプリ右下の追加ボタンでストップウォッチを追加 <br>
・Add a stopwatch by tapping the "+" button in the bottom right corner of the app. <br>
・左から右へのスワイプでストップウォッチを一つ削除 <br>
・Swipe a stopwatch from left to right to delete it. <br>
・アプリ右上の削除ボタンでストップウォッチを全削除 <br>
・Tap the "Delete All" button in the top right corner of the app to delete all stopwatches. <br>
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
(1)頻度は少ないがアプリが停止する<br>
発生開始時期：ReorderableListViewを使用開始した頃から<br>
発生状況：短時間でストップウォッチを連続して動かす操作をおこなったときが多い<br>
現時点の予想１：ReorderableListViewの実装が論理的におかしい？<br>
現時点の予想２：TextFieldとReorderableListViewが干渉？<br>
(1) App crashes infrequently<br>
Start of occurrence: Around the time ReorderableListView started being used<br>
Occurrence conditions: Often occurs when multiple stopwatches are operated consecutively in a short period of time<br>
Current hypothesis 1: Is the implementation of ReorderableListView logically incorrect?<br>
Current hypothesis 2: Interference between TextField and ReorderableListView?<br>
<br>
(2)ストップウォッチ追加ボタンを押したときに、初期状態ではないストップウォッチが出てきてしまうことがある<br>
現時点の予想：_MyHomePageStateクラスの中で、タイマーの状態を管理する実装が論理的におかしい？<br>
(2) Sometimes a stopwatch that is not in the initial state appears when the stopwatch addition button is pressed<br>
Current hypothesis: Is the implementation for managing timer status in the _MyHomePageState class logically incorrect?<br>

## まだ発生していないが予想される現象(Anticipated Issues)
・アプリが待機状態になったときに、ストップウォッチが止まってしまう可能性があるかもしれません<br>
・Stopwatches may stop when the app enters a standby state<br>