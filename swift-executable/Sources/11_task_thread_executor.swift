import CoreFoundation
import Foundation

private final class MainQueueExecutor: TaskExecutor {
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        self.enqueue(unownedJob)
    }

    func enqueue(_ job: UnownedJob) {
        let unownedExecutor = asUnownedTaskExecutor()
        DispatchQueue.main.async {
            job.runSynchronously(on: unownedExecutor)
        }
    }

    func asUnownedTaskExecutor() -> UnownedTaskExecutor {
        UnownedTaskExecutor(ordinary: self)
    }
}

func example11() async {
    let executor = MainQueueExecutor()
    Task.detached(executorPreference: executor) {
        print(2)
    }

    await withTaskExecutorPreference(executor) {
        print(2)
    }
}
