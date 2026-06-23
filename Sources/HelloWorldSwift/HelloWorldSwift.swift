import ElementaryUI

@main
struct HelloWorldSwift {
    static func main() {
        Application(CalculatorApp()).mount(in: .body)
    }
}

@View
struct CalculatorApp {
    @State var display = "0"
    @State var equation = "Ready"
    @State var storedValue: Double? = nil
    @State var pendingOperator: String? = nil
    @State var resetOnNextDigit = false
    @State var justEvaluated = false

    var body: some View {
        main(.class("shell")) {
            section(.class("calculator")) {
                div(.class("shine")) {}

                header(.class("calc-header")) {
                    div {
                        p(.class("eyebrow")) { "Liquid Glass" }
                        h1 { "Calculator" }
                    }
                    div(.class("status-dot")) {}
                }

                section(.class("display-panel")) {
                    div(.class("equation")) { equation }
                    div(.class("display")) { display }
                }

                div(.class("keypad")) {
                    CalcButton(label: "C", classes: "utility", action: clear)
                    CalcButton(label: "⌫", classes: "utility", action: backspace)
                    CalcButton(label: "%", classes: "utility", action: percent)
                    CalcButton(label: "÷", classes: "operator", action: { chooseOperator("÷") })

                    CalcButton(label: "7", action: { inputDigit("7") })
                    CalcButton(label: "8", action: { inputDigit("8") })
                    CalcButton(label: "9", action: { inputDigit("9") })
                    CalcButton(label: "×", classes: "operator", action: { chooseOperator("×") })

                    CalcButton(label: "4", action: { inputDigit("4") })
                    CalcButton(label: "5", action: { inputDigit("5") })
                    CalcButton(label: "6", action: { inputDigit("6") })
                    CalcButton(label: "−", classes: "operator", action: { chooseOperator("−") })

                    CalcButton(label: "1", action: { inputDigit("1") })
                    CalcButton(label: "2", action: { inputDigit("2") })
                    CalcButton(label: "3", action: { inputDigit("3") })
                    CalcButton(label: "+", classes: "operator", action: { chooseOperator("+") })

                    CalcButton(label: "±", classes: "utility", action: toggleSign)
                    CalcButton(label: "0", action: { inputDigit("0") })
                    CalcButton(label: ".", action: inputDecimal)
                    CalcButton(label: "=", classes: "equals", action: evaluate)
                }
            }
        }
    }

    func inputDigit(_ digit: String) {
        if resetOnNextDigit || display == "Error" {
            display = digit
            resetOnNextDigit = false
        } else if display == "0" {
            display = digit
        } else if display.count < 15 {
            display += digit
        }

        if justEvaluated {
            equation = "Ready"
            justEvaluated = false
        }
    }

    func inputDecimal() {
        if resetOnNextDigit || display == "Error" {
            display = "0."
            resetOnNextDigit = false
        } else if !display.contains(".") && display.count < 15 {
            display += "."
        }

        if justEvaluated {
            equation = "Ready"
            justEvaluated = false
        }
    }

    func chooseOperator(_ symbol: String) {
        guard let current = Double(display) else {
            clear()
            return
        }

        if let pending = pendingOperator, let stored = storedValue, !resetOnNextDigit {
            let result = calculate(stored, current, pending)
            display = format(result)
            storedValue = result
        } else {
            storedValue = current
        }

        pendingOperator = symbol
        equation = "\(format(storedValue ?? current)) \(symbol)"
        resetOnNextDigit = true
        justEvaluated = false
    }

    func evaluate() {
        guard let pending = pendingOperator, let stored = storedValue, let current = Double(display) else {
            return
        }

        let result = calculate(stored, current, pending)
        equation = "\(format(stored)) \(pending) \(format(current)) ="
        display = format(result)
        storedValue = nil
        pendingOperator = nil
        resetOnNextDigit = true
        justEvaluated = true
    }

    func clear() {
        display = "0"
        equation = "Ready"
        storedValue = nil
        pendingOperator = nil
        resetOnNextDigit = false
        justEvaluated = false
    }

    func backspace() {
        guard !resetOnNextDigit, display != "Error" else {
            display = "0"
            resetOnNextDigit = false
            return
        }

        if display.count <= 1 || (display.count == 2 && display.first == "-") {
            display = "0"
        } else {
            display = String(display.dropLast())
        }
    }

    func percent() {
        guard let current = Double(display) else { return }
        display = format(current / 100)
    }

    func toggleSign() {
        guard display != "0", display != "Error" else { return }

        if display.first == "-" {
            display = String(display.dropFirst())
        } else {
            display = "-\(display)"
        }
    }

    func calculate(_ lhs: Double, _ rhs: Double, _ symbol: String) -> Double {
        switch symbol {
        case "+": lhs + rhs
        case "−": lhs - rhs
        case "×": lhs * rhs
        case "÷": rhs == 0 ? Double.nan : lhs / rhs
        default: rhs
        }
    }

    func format(_ value: Double) -> String {
        guard !value.isNaN, !value.isInfinite else { return "Error" }
        if value.rounded() == value && value < 1_000_000_000_000 && value > -1_000_000_000_000 {
            return String(Int64(value))
        }
        let text = String(value)
        return text.count > 15 ? String(text.prefix(15)) : text
    }
}

@View
struct CalcButton {
    var label: String
    var classes: String = ""
    var action: () -> Void

    var body: some View {
        button(.type(.button), .class("calc-key \(classes)")) {
            label
        }
        .onClick { action() }
    }
}
