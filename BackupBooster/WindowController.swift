class WindowController {
    static let shared = WindowController()
    private var window: NSWindow?

    private init() {}

    func showWindow() {
        if window == nil {
            window = NSWindow(contentViewController: YourViewController())
        }
        window?.makeKeyAndOrderFront(nil)
    }
}