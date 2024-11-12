import Foundation

private class ArrayStorage: @unchecked Sendable {
    private let queue = DispatchQueue(label: "queue")
    private var currentState = ""

    func add(_ state: String) {
        queue.async {
            let group = DispatchGroup()
            
            print("start add")
            self.currentState = state
            group.enter()
            self.someAyncTask {
                group.leave()
            }
            group.notify(queue: self.queue) {
                assert(state == self.currentState, "race condition")
                print("end add")
            }
        }
    }

    func someAyncTask(completion: @escaping @Sendable () -> Void) {
        queue.async {
            // пауза на 1 секунду
            sleep(1)
            completion()
        }
    }
}

func example13() async {
    let storage = ArrayStorage()
    for index in (0..<10) {
        Task.detached {
            storage.add("\(index)")
        }
    }
}
