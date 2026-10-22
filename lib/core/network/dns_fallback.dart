import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_app/core/helpers/custom_log_print.dart';

class DnsFallback {
  static const Duration _dohTimeout = Duration(seconds: 5);
  static const Duration _cacheTtl = Duration(minutes: 10);
  static final Map<String, _DnsCacheEntry> _cache = {};

  static Future<ConnectionTask<Socket>> connectionFactory(
    Uri uri,
    String? proxyHost,
    int? proxyPort,
  ) async {
    final host = proxyHost ?? uri.host;
    final port = proxyHost != null ? (proxyPort ?? 0) : _resolvedPort(uri);
    final address = await resolve(host);
    final socket = await Socket.connect(address, port);
    if (proxyHost != null || !uri.isScheme('https')) {
      return ConnectionTask.fromSocket<Socket>(
        Future<Socket>.value(socket),
        socket.destroy,
      );
    }
    final secureSocket = await SecureSocket.secure(
      socket,
      host: uri.host,
      onBadCertificate: (certificate) => true,
    );
    return ConnectionTask.fromSocket<Socket>(
      Future<Socket>.value(secureSocket),
      socket.destroy,
    );
  }

  static int _resolvedPort(Uri uri) {
    final port = uri.port;
    if (port != 0) return port;
    return uri.isScheme('https') || uri.isScheme('wss') ? 443 : 80;
  }

  static Future<InternetAddress> resolve(String host) async {
    final parsed = InternetAddress.tryParse(host);
    if (parsed != null) return parsed;
    final cached = _cacheGet(host);
    if (cached != null) return cached;
    try {
      final systemResult = await InternetAddress.lookup(host);
      if (systemResult.isNotEmpty) return systemResult.first;
    } catch (e) {
      CustomPrint.call('DnsFallback: DNS del sistema falló para $host ($e)');
    }
    final resolved = await resolveViaDoh(host);
    _cachePut(host, resolved);
    return resolved;
  }

  static Future<InternetAddress> resolveViaDoh(String host) async {
    final google = await _fetchDoh(
      Uri.parse(
        'https://8.8.8.8/resolve?name=${Uri.encodeQueryComponent(host)}&type=A',
      ),
      accept: 'application/json',
    );
    if (google != null) {
      CustomPrint.call('DnsFallback: $host resuelto vía Google DoH → $google');
      return InternetAddress(google);
    }
    final cloudflare = await _fetchDoh(
      Uri.parse(
        'https://1.1.1.1/dns-query?name=${Uri.encodeQueryComponent(host)}&type=A',
      ),
      accept: 'application/dns-json',
    );
    if (cloudflare != null) {
      CustomPrint.call(
        'DnsFallback: $host resuelto vía Cloudflare DoH → $cloudflare',
      );
      return InternetAddress(cloudflare);
    }
    throw SocketException('Failed host lookup: $host');
  }

  static String? parseDohJson(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return null;
      if (decoded['Status'] != 0) return null;
      final answer = decoded['Answer'];
      if (answer is! List) return null;
      for (final item in answer) {
        if (item is! Map<String, dynamic>) continue;
        if (item['type'] != 1) continue;
        final data = item['data'];
        if (data is! String) continue;
        if (InternetAddress.tryParse(data) != null) return data;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _fetchDoh(Uri uri, {required String accept}) async {
    final client = _newPlainHttpClient();
    client.connectionTimeout = _dohTimeout;
    try {
      final request = await client.getUrl(uri).timeout(_dohTimeout);
      request.headers.set('accept', accept);
      final response = await request.close().timeout(_dohTimeout);
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_dohTimeout);
      if (response.statusCode != 200) return null;
      return parseDohJson(body);
    } catch (e) {
      CustomPrint.call('DnsFallback: DoH falló en ${uri.host} ($e)');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  static HttpClient _newPlainHttpClient() {
    return _PlainHttpOverrides().createHttpClient(null);
  }

  static InternetAddress? _cacheGet(String host) {
    final entry = _cache[host];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(host);
      return null;
    }
    return entry.address;
  }

  static void _cachePut(String host, InternetAddress address) {
    _cache[host] = _DnsCacheEntry(
      address,
      DateTime.now().add(_cacheTtl),
    );
  }
}

class _DnsCacheEntry {
  final InternetAddress address;
  final DateTime expiresAt;

  _DnsCacheEntry(this.address, this.expiresAt);
}

class _PlainHttpOverrides extends HttpOverrides {}
