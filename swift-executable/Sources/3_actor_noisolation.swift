private actor ArrayStorage {
    private var array: [Int] = []
    private let info = "into"

    func add(_ item: Int) {
        array.append(item)
    }

    nonisolated func getInfo() -> String {
        info
    }
}

func example3() async {
    let storage = ArrayStorage()
    await storage.add(1)
    let info = storage.getInfo()
    print(info)
}