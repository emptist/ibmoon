# Multi-Target Implementation Plan

## Overview

This document outlines the plan to implement 3 separate target-specific projects for ibmoon:
- **ibmoonjs** - JavaScript/Node.js target
- **ibmoonc** - C/Native target
- **ibmoonwa** - WebAssembly target

## Goal

Create three working projects that use target-specific FFI implementations to connect to IB TWS/Gateway API, overcoming MoonBit's FFI limitation.

## Implementation Strategy

### Phase 0: Planning (Current Phase)
- [x] Confirm all three projects exist
- [ ] Update README files for each project to specify purpose
- [ ] Create this implementation plan
- [ ] Update todo list

### Phase 1: ibmoonjs Implementation (JavaScript/Node.js)
**Priority: HIGH** - Most commonly used target

#### 1.1 Update README
- [ ] Update `../ibmoonjs/README.md` to specify JavaScript/Node.js purpose
- [ ] Document JavaScript-specific features (Node.js net module)
- [ ] Add installation and usage instructions
- [ ] Include build instructions for JavaScript target

#### 1.2 Configure Project
- [ ] Update `../ibmoonjs/moon.pkg.json` to import ibmoon core
- [ ] Configure FFI links to `../ibmoon/target/js/socket_impl.js`
- [ ] Set target-specific build settings

#### 1.3 Implement Socket Layer
- [ ] Copy `../ibmoon/target/js/socket.mbt` to `../ibmoonjs/socket.mbt`
- [ ] Copy `../ibmoon/target/js/socket_impl.js` to `../ibmoonjs/socket_impl.js`
- [ ] Verify FFI declarations are correct
- [ ] Test socket connection

#### 1.4 Migrate Core Files
- [ ] Copy all core ibmoon files to ibmoonjs:
  - [ ] `types.mbt`, `orders.mbt`, `protocol.mbt`
  - [ ] `encoder.mbt`, `decoder.mbt`
  - [ ] `client.mbt`, `api.mbt`, `handlers.mbt`
- [ ] Remove target-specific code from copied files
- [ ] Ensure all imports work correctly

#### 1.5 Create Tests
- [ ] Create integration tests for JavaScript target
- [ ] Test with live IB API on port 7496
- [ ] Verify all examples work

#### 1.6 Create Examples
- [ ] Create example_managed_accounts.mbt
- [ ] Create example_account_summary.mbt
- [ ] Create example_positions.mbt
- [ ] Create example_connection.mbt

### Phase 2: ibmoonc Implementation (C/Native)
**Priority: MEDIUM** - For native performance

#### 2.1 Update README
- [ ] Update `../ibmoonc/README.md` to specify C/Native purpose
- [ ] Document C-specific features (POSIX sockets)
- [ ] Add installation and usage instructions
- [ ] Include build instructions for C target

#### 2.2 Configure Project
- [ ] Update `../ibmoonc/moon.pkg.json` to import ibmoon core
- [ ] Configure FFI links to `../ibmoon/target/c/socket_impl.c`
- [ ] Set target-specific build settings

#### 2.3 Implement Socket Layer
- [ ] Copy `../ibmoon/target/c/socket.mbt` to `../ibmoonc/socket.mbt`
- [ ] Copy `../ibmoon/target/c/socket_impl.c` to `../ibmoonc/socket_impl.c`
- [ ] Verify FFI declarations are correct
- [ ] Test socket connection

#### 2.4 Migrate Core Files
- [ ] Copy all core ibmoon files to ibmoonc
- [ ] Remove target-specific code from copied files
- [ ] Ensure all imports work correctly

#### 2.5 Create Tests
- [ ] Create integration tests for C target
- [ ] Test with live IB API on port 7496
- [ ] Verify all examples work

#### 2.6 Create Examples
- [ ] Create example_managed_accounts.mbt
- [ ] Create example_account_summary.mbt
- [ ] Create example_positions.mbt
- [ ] Create example_connection.mbt

### Phase 3: ibmoonwa Implementation (WebAssembly)
**Priority: LOW** - For browser environments

#### 3.1 Update README
- [ ] Update `../ibmoonwa/README.md` to specify WebAssembly purpose
- [ ] Document WebAssembly-specific features (browser compatibility)
- [ ] Add installation and usage instructions
- [ ] Include build instructions for WebAssembly target

#### 3.2 Configure Project
- [ ] Update `../ibmoonwa/moon.pkg.json` to import ibmoon core
- [ ] Configure FFI links to `../ibmoon/target/wasm/socket.wat`
- [ ] Set target-specific build settings

#### 3.3 Implement Socket Layer
- [ ] Copy `../ibmoon/target/wasm/socket.mbt` to `../ibmoonwa/socket.mbt`
- [ ] Copy `../ibmoon/target/wasm/socket.wat` to `../ibmoonwa/socket.wat`
- [ ] Verify FFI declarations are correct
- [ ] Test socket connection

#### 3.4 Migrate Core Files
- [ ] Copy all core ibmoon files to ibmoonwa
- [ ] Remove target-specific code from copied files
- [ ] Ensure all imports work correctly

#### 3.5 Create Tests
- [ ] Create integration tests for WebAssembly target
- [ ] Test with live IB API on port 7496
- [ ] Verify all examples work

#### 3.6 Create Examples
- [ ] Create example_managed_accounts.mbt
- [ ] Create example_account_summary.mbt
- [ ] Create example_positions.mbt
- [ ] Create example_connection.mbt

### Phase 4: Documentation & Finalization

#### 4.1 Update Main Documentation
- [ ] Update `../ibmoon/README.md` with links to target-specific projects
- [ ] Update `../ibmoon/docs/SOCKET_FFI_SOLUTION.md` with multi-project approach
- [ ] Update `../ibmoon/docs/TEST_RESULTS_SUMMARY.md` with final results
- [ ] Create migration guide from original ibmoon to target-specific projects

#### 4.2 Create Usage Guide
- [ ] Create `docs/USAGE_GUIDE.md` explaining how to choose the right project
- [ ] Document common patterns across all targets
- [ ] Provide migration examples

#### 4.3 Final Testing
- [ ] Test all three projects with live IB API
- [ ] Verify all examples work across all targets
- [ ] Document any target-specific limitations

## Progress Tracking

### Current Status
- **Phase 0**: In Progress
- **Phase 1** (ibmoonjs): Not Started
- **Phase 2** (ibmoonc): Not Started
- **Phase 3** (ibmoonwa): Not Started
- **Phase 4** (Documentation): Not Started

### Completed Tasks
- [x] Confirm ibmoonjs project exists
- [x] Confirm ibmoonc project exists
- [x] Confirm ibmoonwa project exists

### Next Immediate Steps
1. Update README files for all three projects
2. Start Phase 1: ibmoonjs implementation
3. Test ibmoonjs with live IB API
4. Document results and proceed to Phase 2

## Notes

- All three projects are in the same workspace as ibmoon
- Each project will be a complete, self-contained library
- Core ibmoon files will be copied to each target project
- Target-specific FFI implementations will be integrated into each project
- No changes to the original ibmoon project (it remains as reference)

## Related Documentation

- [`../ibmoon/docs/SOCKET_FFI_SOLUTION.md`](../ibmoon/docs/SOCKET_FFI_SOLUTION.md) - Original FFI solutions
- [`../ibmoon/docs/TEST_RESULTS_SUMMARY.md`](../ibmoon/docs/TEST_RESULTS_SUMMARY.md) - Test results showing FFI limitation
- [`../ibmoon/README.md`](../ibmoon/README.md) - Main ibmoon documentation