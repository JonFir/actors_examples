private actor ArrayStorage {
    private var array: [Int] = []

    func add(_ item: Int) {
        array.append(item)
        print(item)
    }
}

func example1() async {
    let storage = ArrayStorage()
    for index in (0..<1000) {
        Task.detached {
            await storage.add(index)
        }
    }
}