import Foundation

class ThreadSafeClassContainer1 {
    private let lock = NSLock()
    private var array: [Int] = []

    func add(_ item: Int) {
        lock.lock()
        array.append(item)
        lock.unlock()
    }
}

class ThreadSafeClassContainer2: @unchecked Sendable {
    private let queue = DispatchQueue(label: "Sync qeueue")
    private var array: [Int] = []

    func add(_ item: Int) {
        queue.async { [weak self] in
            self?.array.append(item)
        }
    }
}

actor ThreadSafeActorContainer {
    private var array: [Int] = []

    func add(_ item: Int) {
        array.append(item)
    }
}

func q() {
    let storage = ThreadSafeActorContainer()
    Task.detached {
        await storage.add(1)
    }
}

/*
DispatchGlobalExecutor.cpp

static void dispatchEnqueue(dispatch_queue_t queue, SwiftJob *job,
                            dispatch_qos_class_t qos, void *executorQueue) {
  job->schedulerPrivate[Job::DispatchQueueIndex] = executorQueue;
  dispatchEnqueueFunc.load(std::memory_order_relaxed)(queue, job, qos);
}

void swift_task_enqueueGlobalImpl(SwiftJob *job) {
  SwiftJobPriority priority = swift_job_getPriority(job);

  auto queue = getGlobalQueue(priority);

  dispatchEnqueue(queue, job, (dispatch_qos_class_t)priority,
                  DISPATCH_QUEUE_GLOBAL_EXECUTOR);
}

void swift_task_enqueueMainExecutorImpl(SwiftJob *job) {
  assert(job && "no job provided");

  SwiftJobPriority priority = swift_job_getPriority(job);

  // This is an inline function that compiles down to a pointer to a global.
  auto mainQueue = dispatch_get_main_queue();

  dispatchEnqueue(mainQueue, job, (dispatch_qos_class_t)priority, mainQueue);
}

*/

/*
https://developer.apple.com/documentation/swift/isolation()
https://developer.apple.com/documentation/swift/taskexecutor
https://developer.apple.com/documentation/swift/withtaskexecutorpreference(_:isolation:operation:)
*/