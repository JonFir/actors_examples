private actor ArrayStorage {
    private var array: [Int] = []
    private let info = "into"

    func add(_ item: Int) {
        array.append(item)
    }

    func getInfo() -> String {
        info
    }
}

func example2() async {
    let storage = ArrayStorage()
    await storage.add(1)
    let info = await storage.getInfo()
    print(info)
}