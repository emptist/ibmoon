# Contributing to IB MoonBit Wrapper

Thank you for your interest in contributing to the IB MoonBit Wrapper! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

Be respectful, inclusive, and professional in all interactions. We are committed to providing a welcoming environment for all contributors.

## Getting Started

### Prerequisites

- MoonBit compiler (latest stable version)
- Interactive Brokers TWS or Gateway (for testing)
- Paper trading account (recommended for development)
- Git

### Setup Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/ibmoon.git
   cd ibmoon
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/original-owner/ibmoon.git
   ```

4. Install dependencies:
   ```bash
   moon fetch
   ```

5. Run tests to verify setup:
   ```bash
   moon test
   ```

## Development Workflow

### 1. Create a Branch

Create a new branch for your feature or bugfix:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b bugfix/your-bugfix-name
```

Branch naming conventions:
- `feature/` - New features
- `bugfix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions or changes

### 2. Make Changes

Follow the coding standards outlined below.

### 3. Test Your Changes

Always test your changes before submitting:

```bash
# Run all tests
moon test

# Run specific test file
moon test path/to/test_file.mbt

# Update test snapshots if needed
moon test --update
```

### 4. Format Code

Format your code using MoonBit's formatter:

```bash
moon fmt
```

### 5. Type Check

Verify your code compiles without errors:

```bash
moon check
```

### 6. Commit Your Changes

Write clear, descriptive commit messages:

```
feat: add support for market depth data
fix: resolve connection timeout issue
docs: update API reference
test: add integration tests for order placement
```

Commit message format:
- Use imperative mood ("add" not "added")
- Keep first line under 50 characters
- Add detailed body if needed
- Reference issue numbers: `Fixes #123`

### 7. Push and Create Pull Request

Push your branch to your fork:

```bash
git push origin feature/your-feature-name
```

Create a pull request on GitHub with:
- Clear title and description
- Reference related issues
- List changes made
- Include screenshots if applicable

## Coding Standards

### MoonBit Style Guide

#### Naming Conventions

- **Functions**: `snake_case`
  ```moonbit
  pub fn place_order(api : IbApi, order : Order) -> Result[OrderId, ApiError]
  ```

- **Types**: `PascalCase`
  ```moonbit
  pub struct Order { ... }
  pub enum OrderType { ... }
  ```

- **Constants**: `SCREAMING_SNAKE_CASE`
  ```moonbit
  const DEFAULT_PORT : Int = 7497
  ```

- **Variables**: `snake_case`
  ```moonbit
  let order_id = 123
  let mut current_price = 150.0
  ```

#### Code Organization

- Separate logical blocks with `///|` comments
- Keep functions focused and small (< 50 lines when possible)
- Use descriptive names
- Add comments for complex logic

#### Type Safety

- Use `pub struct` for record/product types with named fields (read-only)
- Use `pub enum` for sum/enum types (NOT `pub type`)
- Prefer explicit types over type inference for public APIs
- Use `Result[T, E]` for error handling
- Use `Option[T]` for optional values

#### Error Handling

```moonbit
// Good: Use Result type
pub fn connect(api : IbApi) -> Result[IbApi, ApiError] {
  match socket_connect(api.config.host, api.config.port) {
    Ok(socket) => Ok({ api with socket: Some(socket) })
    Err(e) => Err(ConnectionFailed("Failed to connect: " + e.to_string()))
  }
}

// Bad: Panic on error
pub fn connect(api : IbApi) -> IbApi {
  let socket = socket_connect(api.config.host, api.config.port).unwrap()
  { api with socket: Some(socket) }
}
```

#### Documentation

Document all public functions and types:

```moonbit
/// Connects to the IB TWS or Gateway server.
/// 
/// # Arguments
/// 
/// * `api` - The API instance to connect
/// 
/// # Returns
/// 
/// Returns `Ok(connected_api)` on success, `Err(ApiError)` on failure.
/// 
/// # Example
/// 
/// ```moonbit
/// match connect(api) {
///   Ok(connected) => println("Connected!")
///   Err(e) => println("Failed: " + e.to_string())
/// }
/// ```
pub fn connect(api : IbApi) -> Result[IbApi, ApiError] {
  // implementation
}
```

### Testing Standards

#### Unit Tests

- Test all public functions
- Test both success and error paths
- Test edge cases
- Use descriptive test names

```moonbit
test "place_market_order_success" {
  let api = new_ib_api("127.0.0.1", 7497, 1)
  let contract = stock_contract("AAPL", "SMART", "USD")
  
  match place_market_order(api, contract, Buy, 100.0) {
    Ok(order_id) => inspect(order_id)
    Err(e) => inspect(e)
  }
}

test "place_market_order_invalid_contract" {
  let api = new_ib_api("127.0.0.1", 7497, 1)
  let contract = { default_contract() with symbol: "" }
  
  match place_market_order(api, contract, Buy, 100.0) {
    Ok(_) => inspect("Expected error")
    Err(e) => inspect(e)
  }
}
```

#### Integration Tests

- Use paper trading accounts
- Test real API interactions
- Clean up test data
- Mock external dependencies when possible

#### Test Coverage

Aim for 80%+ code coverage. Check coverage:

```bash
moon test
moon coverage analyze > uncovered.log
```

### Protocol Implementation

When adding new protocol message handlers:

1. Add message type to `protocol.mbt`
2. Implement encoder in `encoder.mbt`
3. Implement decoder in `decoder.mbt`
4. Add handler in `client.mbt`
5. Add high-level API function in `api.mbt`
6. Write tests for all layers
7. Update documentation

Example:

```moonbit
// protocol.mbt
pub enum MessageType {
  // ... existing messages
  ReqMktDepth
}

// encoder.mbt
pub fn write_market_depth_request(enc : Encoder, req_id : Int, contract : Contract, num_rows : Int) -> Encoder {
  let enc = write_int(enc, req_id)
  let enc = write_contract(enc, contract)
  let enc = write_int(enc, num_rows)
  // ... more fields
  enc
}

// decoder.mbt
pub fn read_market_depth_update(dec : Decoder) -> Result[(MarketDepthUpdate, Decoder), DecodeError] {
  // implementation
}

// client.mbt
pub fn req_market_depth(client : Client, contract : Contract, num_rows : Int) -> Result[RequestId, ClientError] {
  // implementation
}

// api.mbt
pub fn get_market_depth(api : IbApi, contract : Contract, rows : Int) -> Result[RequestId, ApiError] {
  // implementation
}
```

## Documentation

### Code Documentation

- Document all public APIs
- Include usage examples
- Explain parameters and return values
- Note any limitations or edge cases

### README Updates

When adding features:
- Update the "Features" section
- Add usage examples
- Update API reference
- Update project status

### CHANGELOG

Maintain a changelog:

```markdown
## [Unreleased]

### Added
- Market depth data support
- Order modification API

### Fixed
- Connection timeout handling
- Memory leak in message processing

### Changed
- Improved error messages
- Updated to IB API v10.20
```

## Submitting Changes

### Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows style guidelines
- [ ] All tests pass (`moon test`)
- [ ] Code is formatted (`moon fmt`)
- [ ] Type checking passes (`moon check`)
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] PR description is detailed
- [ ] No merge conflicts

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe tests performed

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Changelog updated

## Related Issues
Fixes #123
Related to #456
```

### Review Process

1. Automated checks must pass
2. At least one maintainer approval required
3. Address all review comments
4. Update PR based on feedback
5. Request re-review when ready

## Reporting Issues

### Bug Reports

When reporting bugs, include:

- **Description**: Clear description of the problem
- **Steps to Reproduce**: Detailed steps to reproduce
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**: OS, MoonBit version, IB API version
- **Logs**: Relevant error messages or logs
- **Code Example**: Minimal reproduction case

### Feature Requests

When requesting features:

- **Description**: Clear description of the feature
- **Use Case**: Why this feature is needed
- **Proposed Solution**: How you envision it working
- **Alternatives**: Other approaches considered
- **Additional Context**: Any relevant information

### Issue Template

```markdown
## Type
- [ ] Bug
- [ ] Feature Request
- [ ] Documentation
- [ ] Other

## Description
[Description]

## Steps to Reproduce (if applicable)
1. 
2. 
3. 

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., macOS, Linux, Windows]
- MoonBit Version: [version]
- IB API Version: [version]
- Node.js Version (if using JS target): [version]

## Additional Context
[Any other relevant information]
```

## Development Phases

This project follows the development plan outlined in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md). Key phases:

1. **Phase 1**: Socket Implementation (FFI)
2. **Phase 2**: Protocol Enhancement
3. **Phase 3**: Client Integration
4. **Phase 4**: High-Level API Enhancement
5. **Phase 5**: Testing & Quality Assurance
6. **Phase 6**: Advanced Features
7. **Phase 7**: Production Readiness

When contributing, consider which phase your work aligns with and coordinate with maintainers.

## Getting Help

- Check existing documentation
- Review test files for examples
- Search existing issues
- Ask questions in GitHub Discussions
- Join the community chat (if available)

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation

Thank you for contributing! 🙏