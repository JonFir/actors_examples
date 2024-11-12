import Foundation

@main
struct Testing {
    static func main() {
        let example = Int(CommandLine.arguments[1])!
        Task.detached {
            switch example {
            case 0: await example0()
            case 1: await example1()
            case 2: await example2()
            case 3: await example3()
            case 4: await example4()
            case 5: await example5()
            case 6: await example6()
            case 7: await example7()
            case 8: await example8()
            case 9: await example9()
            case 10: await example10()
            case 11: await example11()
            case 12: await example12()
            case 13: await example13()
            case 14: await example14()
            case 15: await example15()
            default:
                exit(0)
            }
        }

        RunLoop.current.run()
    }
}