import Dependencies

extension DependencyValues {
  public var api: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

extension APIClient: TestDependencyKey {
    public static var testValue: APIClient {
        .one
    }
    public static var previewValue: APIClient {
        .dummy
    }
}
