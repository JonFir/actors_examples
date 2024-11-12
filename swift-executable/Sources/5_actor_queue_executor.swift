import Foundation

private final class QueueExecutor: SerialExecutor {
    private let queue = DispatchQueue(label: "qeueue")

    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedSerialExecutor()
        queue.async {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
    }

    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}

private actor ArrayStorage {
    private let executor = QueueExecutor()
    
    private var array: [Int] = []

    func add(_ item: Int) {
        array.append(item)
    }

    nonisolated var unownedExecutor: UnownedSerialExecutor {
        self.executor.asUnownedSerialExecutor()
    }
}

func example5() async {
    let storage = ArrayStorage()
    await storage.add(1)
}
