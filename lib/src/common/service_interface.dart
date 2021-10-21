
/// Enforcing all service classes to operate in the same way
///
/// Ideally, a [ProviderService] should concentrate on providing on on entity,
/// [T].
abstract class ProviderService<T> {
  /// This method initialises all properties that exist on the service
  getAll();

  /// Refresh the state of the library from a repository
  refresh();
}