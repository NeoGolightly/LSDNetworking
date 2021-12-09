# ``LSDNetworking/LSD``

```swift
let server = Server(scheme: .https, 
                    host: "yourRootServer.com")
let lsd = LSD(server: server)
let trip = try await lsd.turnOn {
  Endpoint(basePath: "/todos")
  Request(.GET(returnType: [Todo].self))
}

let todos = try await trip.tuneIn()
```

## Topics

### Initializers

- ``LSD/init(server:urlSession:)``

### Progress

- ``LSD/progress``

