protocol ComponentProtocol {
    associatedtype ViewProperties
    
    func update(with viewProperties: ViewProperties)
}
