import 'dart:async';
import 'dart:io';

/// copied from https://chromium.googlesource.com/external/github.com/dart-lang/test/+/master/pkgs/test_core/lib/src/util/io.dart#147

/// Whether this computer supports binding to IPv6 addresses.
var _maySupportIPv6 = true;

/// Returns a port that is probably, but not definitely, not in use.
///
/// This has a built-in race condition: another process may bind this port at
/// any time after this call has returned. If at all possible, callers should
/// use [getUnusedPort] instead.
Future<int> getUnsafeUnusedPort() async {
  late int port;
  if (_maySupportIPv6) {
    try {
      final socket = await ServerSocket.bind(InternetAddress.loopbackIPv6, 0, v6Only: true);
      port = socket.port;
      await socket.close();
    } on SocketException {
      _maySupportIPv6 = false;
    }
  }
  if (!_maySupportIPv6) {
    final socket = await RawServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = socket.port;
    await socket.close();
  }
  return port;
}

/// Repeatedly finds a probably-unused port on localhost and passes it to
/// [tryPort] until it binds successfully.
///
/// [tryPort] should return a non-`null` value or a Future completing to a
/// non-`null` value once it binds successfully. This value will be returned
/// by [getUnusedPort] in turn.
///
/// This is necessary for ensuring that our port binding isn't flaky for
/// applications that don't print out the bound port.
Future<T> getUnusedPort<T extends Object>(FutureOr<T> Function(int port) tryPort) async {
  T? value;
  await Future.doWhile(() async {
    value = await tryPort(await getUnsafeUnusedPort());
    return value == null;
  });
  return value!;
}
