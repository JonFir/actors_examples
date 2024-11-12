@globalActor
private actor SharedActor: GlobalActor {
    static let shared = SharedActor()

    private init() {}
}

func example9() async {
    Task.detached { @SharedActor in
        for _ in 0..<1000 {
            print(1)
        }
    }
    Task.detached { @SharedActor in
        for _ in 0..<1000 {
            print(2)
        }
    }
}
