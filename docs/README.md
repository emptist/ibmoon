# IB MoonBit Wrapper - Documentation

This directory contains comprehensive documentation for the IB MoonBit Wrapper project.

## Documentation Index

### Getting Started
- **[../README.md](../README.md)** - Main project README with quick start guide and examples
- **[../CONTRIBUTING.md](../CONTRIBUTING.md)** - Contributing guidelines

### Development Documentation
- **[DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md)** - Detailed development roadmap, architecture, and implementation phases
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - High-level project overview and goals
- **[PROJECT_COMPLETION_SUMMARY.md](PROJECT_COMPLETION_SUMMARY.md)** - Complete project completion summary with statistics

### Technical Documentation
- **[FFI_INTEGRATION_GUIDE.md](FFI_INTEGRATION_GUIDE.md)** - Comprehensive guide to Foreign Function Interface integration
- **[FFI_IMPLEMENTATIONS_SUMMARY.md](FFI_IMPLEMENTATIONS_SUMMARY.md)** - Summary of all FFI implementations (JavaScript, WebAssembly, C)
- **[FFI_INTEGRATION_COMPLETE.md](FFI_INTEGRATION_COMPLETE.md)** - Status of FFI integration completion
- **[JAVASCRIPT_FFI_STATUS.md](JAVASCRIPT_FFI_STATUS.md)** - JavaScript FFI implementation status and details
- **[HANDLERS_DOCUMENTATION.md](HANDLERS_DOCUMENTATION.md)** - Message handler system documentation
- **[SOCKET_TESTS_SUMMARY.md](SOCKET_TESTS_SUMMARY.md)** - Socket layer test documentation

### Testing Documentation
- **[INTEGRATION_TESTS_SUMMARY.md](INTEGRATION_TESTS_SUMMARY.md)** - Integration tests with live IB API (read-only operations)

### Examples and Tutorials
- **[ACCOUNT_SUMMARY_EXAMPLE.md](ACCOUNT_SUMMARY_EXAMPLE.md)** - Example code for retrieving account summary data
- **[MANAGED_ACCOUNTS_EXAMPLE.md](MANAGED_ACCOUNTS_EXAMPLE.md)** - Example code for retrieving all account IDs

### Project Management
- **[AGENTS.md](AGENTS.md)** - Agent task list and assignment tracking

## Quick Links

### For Users
- Start with [Main README](../README.md) for installation and usage
- See [Account Summary Example](ACCOUNT_SUMMARY_EXAMPLE.md) for account data retrieval
- See [Managed Accounts Example](MANAGED_ACCOUNTS_EXAMPLE.md) for retrieving account IDs
- See [Integration Tests Summary](INTEGRATION_TESTS_SUMMARY.md) for testing with live API
- Check [Project Completion Summary](PROJECT_COMPLETION_SUMMARY.md) for project status

### For Developers
- Review [Development Plan](DEVELOPMENT_PLAN.md) for architecture and roadmap
- Read [FFI Integration Guide](FFI_INTEGRATION_GUIDE.md) for platform-specific integration
- See [Handlers Documentation](HANDLERS_DOCUMENTATION.md) for message handling
- Check [FFI Implementations Summary](FFI_IMPLEMENTATIONS_SUMMARY.md) for platform details

### For Contributors
- Read [Contributing Guide](../CONTRIBUTING.md) for contribution guidelines
- Review [Development Plan](DEVELOPMENT_PLAN.md) for implementation phases
- Check [Agents](AGENTS.md) for task assignments

## Project Status

**Version**: 1.0.0  
**Status**: ✅ Complete  
**Test Coverage**: 56/56 tests passing (100%)  
**Platforms**: JavaScript, WebAssembly, C/Native  

## Key Features

- ✅ Complete IB API data types
- ✅ Socket communication layer
- ✅ Binary protocol encoding/decoding
- ✅ Connection manager with state tracking
- ✅ Event-driven callback system
- ✅ Message handlers for 100+ IB API message types
- ✅ Cross-platform FFI support (JS, WASM, C)
- ✅ Comprehensive test suite
- ✅ Extensive documentation

## Documentation Structure

```
docs/
├── README.md                           # This file - documentation index
├── DEVELOPMENT_PLAN.md                 # Development roadmap
├── PROJECT_SUMMARY.md                  # Project overview
├── PROJECT_COMPLETION_SUMMARY.md       # Completion summary
├── FFI_INTEGRATION_GUIDE.md          # FFI integration guide
├── FFI_IMPLEMENTATIONS_SUMMARY.md      # FFI implementations summary
├── FFI_INTEGRATION_COMPLETE.md         # FFI completion status
├── JAVASCRIPT_FFI_STATUS.md          # JavaScript FFI details
├── HANDLERS_DOCUMENTATION.md          # Message handlers docs
├── SOCKET_TESTS_SUMMARY.md            # Socket tests docs
├── INTEGRATION_TESTS_SUMMARY.md       # Integration tests docs
├── ACCOUNT_SUMMARY_EXAMPLE.md         # Account summary example
├── MANAGED_ACCOUNTS_EXAMPLE.md        # Managed accounts example
└── AGENTS.md                         # Agent task list
```

## Support

For questions or issues:
- Check the relevant documentation file
- Review the main [README](../README.md)
- Open an issue on GitHub

## License

Apache-2.0