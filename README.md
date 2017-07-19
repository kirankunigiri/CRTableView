# Comments & Replies TableView

## About
An example of how to implement a comment and reply system with a table view in iOS. Written in Swift.

## Features
In this table view, you can show comments and any number of replies for each comment by default. When a comment has more replies, you can show or hide more comments by using a toggle button. This feature is similar to that of Youtube and Facebook comments.

## How it works
This example is just an ordinary table view, but the replies toggle button uses constraints at different priorities to be able to easily hide and unhide it. The cells are also using `UITableViewAutomaticDimension` to dynamically resize.