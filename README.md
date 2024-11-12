# SystemVerilog Synchronous FIFO Verification

## Project Overview
This project focuses on verifying a synchronous FIFO using SystemVerilog and QuestaSim. The verification plan documents the testing strategy, identified bugs, and ensures thorough testing of control signals and data paths.

## Tools Used
- SystemVerilog
- SystemVerilog Assertions (SVA)
- QuestaSim

## Key Features
- **Verification Plan:** A detailed verification plan documenting testing strategies and bugs.
- **Golden Model Comparison:** Output data verified against a Golden Model.
- **Control Signal Checks:** Assertions for key signals like full, empty, almost_full, almost_empty, and overflow.
- **Functional Testbench:** Includes monitor, scoreboard, and coverage collection.
- **Constraints and Cross-Coverage:** Ensures comprehensive testing across control signals.
- **Coverage Reports:** Detailed reports for functional coverage and assertions.

## Project Structure
- **src/**: SystemVerilog testbench, Golden Model, and assertion files.
- **simulations/**: Simulation results and coverage reports.
- **docs/**: Verification plan and bug documentation.

## How to Run
1. Clone the repository.
2. Open in QuestaSim.
3. Run `fifo.do` file to compile, simulate, and generate reports.

## Results
- Coverage reports for functional and assertion metrics.
- Bug documentation with detailed explanations and solutions.