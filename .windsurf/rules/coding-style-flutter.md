---
trigger: model_decision
description: When developing flutter to integrated with backend with gRPC should follow this spec as general requirements and specs.
---

# Flutter Development Guide

## Project Structure
- code under /src/
- Use BLoC pattern for state management
- Organize code into `lib/bloc`, `lib/models`, `lib/screens`, `lib/services`
- Use `dart-define` for brand/tenant selection

## Coding Style
- Follow Dart/Flutter style guide
- Use null safety throughout the codebase
- Write all comments and documentation in English
- Prefer stateless widgets unless state is needed
- Use async/await for all network and DB operations

## Networking
- Use `web_socket_channel` for WebSocket connections
- Handle connection errors and reconnections gracefully
- Serialize all messages as JSON

## Offline/Cache
- Use `hive` or `shared_preferences` for local cache
- Support offline message access and restoration

## Security
- Never store private keys or secrets in plain text
- Use secure storage for sensitive data
- Implement end-to-end encryption for all messages

---
_Update this guide as the project evolves._