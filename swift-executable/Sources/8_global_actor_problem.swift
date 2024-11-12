func example8() async {
    Task.detached {
        for _ in 0..<1000 {
            print(1)
        }
    }
    Task.detached {
        for _ in 0..<1000 {
            print(2)
        }
    }
}
