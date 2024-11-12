import CoreFoundation
import Foundation

private final class QueueExecutor: SerialExecutor {
    nonisolated(unsafe) private var runLoop: CFRunLoop?

    init() async {
        await runThread()
    }

    private func runThread() async {
        let _: Void = await withCheckedContinuation { continuation in
            Thread.detachNewThread { [weak self] in
                self?.runLoop = CFRunLoopGetCurrent()
                let emptyPortForKeepRunLoopRuning = SocketPort()
                RunLoop.current.add(emptyPortForKeepRunLoopRuning, forMode: .default)
                continuation.resume()
                while self != nil {
                    RunLoop.current.run(until: .now + 1)
                }
            }
        }
    }

    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedSerialExecutor()
        CFRunLoopPerformBlock(runLoop, kCFRunLoopDefaultMode) {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
        CFRunLoopWakeUp(runLoop)
    }

    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}

private actor ArrayStorage {
    private let executor: QueueExecutor
    private var array: [Int] = []

    init() async {
        self.executor = await QueueExecutor()
    }

    func add(_ item: Int) {
        array.append(item)
        print(Thread.current)
    }

    nonisolated var unownedExecutor: UnownedSerialExecutor {
        self.executor.asUnownedSerialExecutor()
    }
}

func example7() async {
    let storage = await ArrayStorage()

    for index in (0..<1000) {
        Task {
            await storage.add(index)
        }
    }
}
