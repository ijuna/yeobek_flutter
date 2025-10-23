sealed class Id {
  final String value;
  const Id(this.value);
}

final class UserId extends Id {
  const UserId(super.value);
}
