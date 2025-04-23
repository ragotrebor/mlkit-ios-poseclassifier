//
//  PriorityQueue.swift
//  Boxibox
//
//  Created by Roberto García on 17-01-25.
//

struct PriorityQueue<T> {
    private var heap: [T]
    private var comparator: (T, T) -> Bool

    init(comparator: @escaping (T, T) -> Bool) {
        self.heap = []
        self.comparator = comparator
    }

    var isEmpty: Bool {
        return heap.isEmpty
    }

    var count: Int {
        return heap.count
    }

    func peek() -> T? {
        return heap.first
    }

    mutating func add(_ element: T) {
        heap.append(element)
        siftUp(from: heap.count - 1)
    }

    mutating func poll() -> T? {
        guard !heap.isEmpty else { return nil }
        if heap.count == 1 {
            return heap.removeFirst()
        }
        let top = heap[0]
        heap[0] = heap.removeLast()
        siftDown(from: 0)
        return top
    }

    private mutating func siftUp(from index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && comparator(heap[child], heap[parent]) {
            heap.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }

    private mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let leftChild = 2 * parent + 1
            let rightChild = 2 * parent + 2
            var candidate = parent

            if leftChild < heap.count && comparator(heap[leftChild], heap[candidate]) {
                candidate = leftChild
            }
            if rightChild < heap.count && comparator(heap[rightChild], heap[candidate]) {
                candidate = rightChild
            }
            if candidate == parent {
                break
            }
            heap.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

extension PriorityQueue: Sequence {
    func makeIterator() -> IndexingIterator<[T]> {
        return heap.makeIterator()
    }
}


