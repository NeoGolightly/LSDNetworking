# LSDNetworking

Swift networking DSL around URLComponents, URLRequest and URLSession with Swifts new async/await concurrency system.

## Overview

```swift
let server = Server(scheme: .https,
                    host: "yourRootServer.com")
let lsd = LSD(server: server)
let todos = try await lsd.turnOn {
  Endpoint(basePath: "/todos")
  Request(.GET(returnType: [Todo].self))
}.tuneIn()
```

**Show the progress**

You can use LSDs ``LSD/progress`` of type ``LSDProgressType`` to get the progress. Set an id to filter different progress.

```swift
let id = UUID().uuidString
lsd.progress.map{ $0[id] }.sink { progress in
  print(progress?.progress ?? 0)
}.store(in: &subscriptions)

let newTodo = Todo(id: nil, title: "New Todo!")
let newTodoReturn = try await lsd.turnOn {
  Endpoint(basePath: "/todos")
  Request(.POST(body: newTodo, returnType: Todo.self))
}.tuneIn(progressID: id)
```
