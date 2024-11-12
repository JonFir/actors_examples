private class ArrayStorage: @unchecked Sendable {
    private var array: [Int] = []

    func add(_ item: Int) {
        array.append(item)
    }
}

func example0() async {
    let storage = ArrayStorage()
    for index in (0..<1000) {
        Task.detached {
            storage.add(index)
        }
    }
}