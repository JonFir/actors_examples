private actor ArrayStorage {
    private var currentState = ""

    func add(_ state: String) async {
        print("start add")
        currentState = state
        await someAyncTask()
        assert(state == currentState, "race condition")
        print("end add")
    }

    func someAyncTask() async {
        // пауза на 1 секунду
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

func example12() async {
    let storage = ArrayStorage()
    for index in (0..<10) {
        Task.detached {
            await storage.add("\(index)")
        }
    }
}
