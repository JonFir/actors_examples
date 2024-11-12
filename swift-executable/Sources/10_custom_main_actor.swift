import Foundation

private final class MainQueueExecutor: SerialExecutor {
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedSerialExecutor()
        DispatchQueue.main.async {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
    }

    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}

@globalActor
private actor CustomMainActor: GlobalActor {
    static let sharedUnownedExecutor = MainQueueExecutor()
    static let shared = CustomMainActor()

    nonisolated var unownedExecutor: UnownedSerialExecutor { 
        Self.sharedUnownedExecutor.asUnownedSerialExecutor()
    }
}

func example10() async {
    Task.detached { @CustomMainActor in
        print(2)
    }
    Task.detached { @CustomMainActor in
        print(2)
    }
}
