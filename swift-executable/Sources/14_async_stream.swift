import Foundation

private class ArrayStorage: @unchecked Sendable {
    private(set) var continuation: AsyncStream<String>.Continuation!
    private var currentState = ""

    init() {
        let stream =  AsyncStream<String> { continuation in
            self.continuation = continuation
        }

        Task.detached {
            for await state in stream {
                await self.add(state)
            }
        }
    }

    private func add(_ state: String) async {
        print("start add")
        currentState = state
        await someAyncTask()
        assert(state == currentState, "race condition")
        print("end add")
    }

    private func someAyncTask() async {
        // пауза на 1 секунду
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

func example14() async {
    let storage = ArrayStorage()
    for index in (0..<10) {
        Task.detached {
            _ = storage.continuation.yield("\(index)")
        }
    }
}


