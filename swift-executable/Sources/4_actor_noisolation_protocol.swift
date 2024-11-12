private protocol Duck {
    func sayCrya() -> String
}

private actor ArrayStorage: Duck {
    private var array: [Int] = []
    private let info = "into"

    func add(_ item: Int) {
        array.append(item)
    }

    nonisolated func getInfo() -> String {
        info
    }

    nonisolated func sayCrya() -> String {
        "crya"
    }
}

func example4() async {
    let storage = ArrayStorage()
    await storage.add(1)
    let info = storage.getInfo()
    print(info)
}