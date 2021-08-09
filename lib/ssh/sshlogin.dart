import 'package:ssh2/ssh2.dart';

sshconnect() async {
  await client.connect();
  var result = await client.execute("ls");
  print(result);
}

sshshare({host, port, username, password}) {
  host = host;
  port = port;
  username = username;
  password = password;
}

var host;
var port;
var username;
var password;

var client = new SSHClient(
  host: host,
  port: port,
  username: username,
  passwordOrKey: password,
);
