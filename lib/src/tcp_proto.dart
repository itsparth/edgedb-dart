import 'dart:convert';
import 'dart:io';

import 'package:edgedb/src/base_proto.dart';

import 'errors/errors.dart';
import 'primitives/buffer.dart';
import 'primitives/transport.dart';
import 'primitives/message_types.dart';
import 'primitives/proto_version.dart';
import 'utils/bytes_equal.dart';

import 'scram.dart';

enum AuthenticationStatus {
  authOK(0),
  authSASL(10),
  authSASLContinue(11),
  authSASLFinal(12);

  final int value;
  const AuthenticationStatus(this.value);
}

class TCPProtocol extends BaseProtocol {
  @override
  Future<void> connect(
      {required String host,
      required int port,
      String? database,
      required String username,
      String? password}) async {
    final sock = await SecureSocket.connect(host, port,
        onBadCertificate: (certificate) => true,
        supportedProtocols: ['edgedb-binary']);
    print(sock);
    print(sock.selectedProtocol);

    transport = MessageTransport(sock, sock);

    final handshake = WriteMessageBuffer(ClientMessageType.ClientHandshake)
      ..writeInt16(protoVer.hi)
      ..writeInt16(protoVer.lo)
      ..writeInt16(2)
      ..writeString('user')
      ..writeString(username)
      ..writeString('database')
      ..writeString(database ?? 'edgedb')
      ..writeInt16(0)
      ..endMessage();

    transport.sendMessage(handshake);

    while (true) {
      final message = await transport.takeMessage();

      switch (message.messageType) {
        case MessageType.ServerHandshake:
          final hi = message.readInt16();
          final lo = message.readInt16();

          message
            ..ignoreHeaders()
            ..finishMessage();

          final proposed = ProtocolVersion(hi, lo);

          if (proposed > protoVer || minProtoVer > proposed) {
            throw ProtocolError('the server requested an unsupported version '
                'of the protocol $hi.$lo');
          }

          protocolVersion = proposed;
          break;
        case MessageType.Authentication:
          final status = message.readInt32();

          if (status == AuthenticationStatus.authOK.value) {
            message.finishMessage();
          } else if (status == AuthenticationStatus.authSASL.value) {
            await authSASL(
                message: message, username: username, password: password);
          } else {
            throw ProtocolError('unsupported authentication method requested '
                'by the server: $status');
          }
          break;
        case MessageType.ServerKeyData:
          serverSecret = message.readBytes(32);
          message.finishMessage();
          break;
        case MessageType.ErrorResponse:
          throw parseErrorMessage(message);
        case MessageType.ReadyForCommand:
          parseSyncMessage(message);

          connected = true;
          print('connected');
          return;
        case MessageType.StateDataDescription:
          break;
        default:
          fallthrough(message);
      }
    }
  }

  Future<void> authSASL(
      {required ReadMessageBuffer message,
      required String username,
      String? password}) async {
    final numMethods = message.readInt32();
    if (numMethods <= 0) {
      throw ProtocolError(
          "the server requested SASL authentication but did not offer any methods");
    }

    final methods = [];
    var foundScram256 = false;
    for (var i = 0; i < numMethods; i++) {
      final method = utf8.decode(message.readLenPrefixedBytes());
      if (method == "SCRAM-SHA-256") {
        foundScram256 = true;
      }
      methods.add(method);
    }

    message.finishMessage();

    if (!foundScram256) {
      throw ProtocolError(
          'the server offered the following SASL authentication '
          'methods: ${methods.join(", ")}, none are supported.');
    }

    final clientNonce = generateNonce();
    final clientFirst = buildClientFirstMessage(clientNonce, username);

    final wb =
        WriteMessageBuffer(ClientMessageType.AuthenticationSASLInitialReponse)
          ..writeString("SCRAM-SHA-256")
          ..writeString(clientFirst[0])
          ..endMessage();
    transport.sendMessage(wb);

    message = await _ensureNextMessage(MessageType.Authentication);
    var status = message.readInt32();
    if (status != AuthenticationStatus.authSASLContinue.value) {
      throw ProtocolError(
          'expected SASLContinue from the server, received $status');
    }

    final serverFirst = message.readString();
    message.finishMessage();

    final serverFirstMessage = parseServerFirstMessage(serverFirst);

    final clientFinalMessage = buildClientFinalMessage(
        password ?? '',
        serverFirstMessage.salt,
        serverFirstMessage.iterCount,
        clientFirst[1],
        serverFirst,
        serverFirstMessage.nonce);

    final wb2 = WriteMessageBuffer(ClientMessageType.AuthenticationSASLResponse)
      ..writeString(clientFinalMessage.msg)
      ..endMessage();
    transport.sendMessage(wb2);

    message = await _ensureNextMessage(MessageType.Authentication);
    status = message.readInt32();
    if (status != AuthenticationStatus.authSASLFinal.value) {
      throw ProtocolError(
          'expected SASLFinal from the server, received $status');
    }

    final serverFinal = message.readString();
    message.finishMessage();

    final serverSig = parseServerFinalMessage(serverFinal);

    if (!serverSig.bytesEqual(clientFinalMessage.serverProof)) {
      throw ProtocolError("server SCRAM proof does not match");
    }
  }

  Future<ReadMessageBuffer> _ensureNextMessage(
      MessageType expectedMessageType) async {
    final message = await transport.takeMessage();

    if (message.messageType == MessageType.ErrorResponse) {
      throw parseErrorMessage(message);
    } else if (message.messageType == expectedMessageType) {
      return message;
    } else {
      throw UnexpectedMessageError(
          'expected ${expectedMessageType.name} from the server, received ${message.messageType.name}');
    }
  }
}
