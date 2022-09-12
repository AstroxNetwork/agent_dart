class AgentError extends Error {
  /// Creates an agent error with the provided [message].
  AgentError([this.message]);

  /// Message describing the agent error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return 'Agent failed: ${Error.safeToString(message)}';
    }
    return 'Agent failed';
  }
}
