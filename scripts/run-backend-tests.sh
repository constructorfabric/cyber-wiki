#!/bin/bash
#
# Run CyberWiki Backend Tests
# Usage: ./scripts/run-backend-tests [options] [pytest options]
#
# Options:
#   --coverage, -c     Run tests with coverage report
#   --open, -o         Open HTML coverage report in browser (requires --coverage)
#   --help, -h         Show this help message
#
# Examples:
#   ./scripts/run-backend-tests                      # Run all tests
#   ./scripts/run-backend-tests -v                   # Verbose output
#   ./scripts/run-backend-tests --coverage           # Run with coverage
#   ./scripts/run-backend-tests --coverage --open    # Run with coverage and open report
#   ./scripts/run-backend-tests -c -o                # Short form
#   ./scripts/run-backend-tests src/users/tests/ -v  # Test specific module
#

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse custom flags
COVERAGE=false
OPEN_REPORT=false
PYTEST_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --coverage|-c)
            COVERAGE=true
            shift
            ;;
        --open|-o)
            OPEN_REPORT=true
            shift
            ;;
        --help|-h)
            echo "Run CyberWiki Backend Tests"
            echo ""
            echo "Usage: ./scripts/run-backend-tests [options] [pytest options]"
            echo ""
            echo "Options:"
            echo "  --coverage, -c     Run tests with coverage report"
            echo "  --open, -o         Open HTML coverage report in browser (requires --coverage)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./scripts/run-backend-tests                      # Run all tests"
            echo "  ./scripts/run-backend-tests -v                   # Verbose output"
            echo "  ./scripts/run-backend-tests --coverage           # Run with coverage"
            echo "  ./scripts/run-backend-tests --coverage --open    # Run with coverage and open report"
            echo "  ./scripts/run-backend-tests -c -o                # Short form"
            echo "  ./scripts/run-backend-tests src/users/tests/ -v  # Test specific module"
            exit 0
            ;;
        *)
            PYTEST_ARGS+=("$1")
            shift
            ;;
    esac
done

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/wsrc/constructorfabric/cyber-wiki-back"

if [ "$COVERAGE" = true ]; then
    echo -e "${BLUE}📊 CyberWiki Backend Tests with Coverage${NC}"
else
    echo -e "${BLUE}🧪 CyberWiki Backend Tests${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if backend directory exists
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}❌ Backend directory not found: $BACKEND_DIR${NC}"
    exit 1
fi

# Check if venv exists
if [ ! -d "$BACKEND_DIR/venv" ]; then
    echo -e "${RED}❌ Virtual environment not found: $BACKEND_DIR/venv${NC}"
    echo -e "${YELLOW}   Please create it first: cd $BACKEND_DIR && python -m venv venv${NC}"
    exit 1
fi

# Navigate to backend directory
cd "$BACKEND_DIR"

# Activate virtual environment
echo -e "${GREEN}📦 Activating virtual environment...${NC}"
source venv/bin/activate

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo -e "${YELLOW}⚠️  pytest not found. Installing test dependencies...${NC}"
    pip install -r requirements-dev.txt
fi

# Build pytest command
if [ "$COVERAGE" = true ]; then
    echo -e "${GREEN}🚀 Running tests with coverage...${NC}"
    echo ""
    
    if [ ${#PYTEST_ARGS[@]} -eq 0 ]; then
        # No additional args, run with default verbose
        pytest --cov=src --cov-report=html --cov-report=term-missing -v
    else
        # Pass additional args to pytest
        pytest --cov=src --cov-report=html --cov-report=term-missing "${PYTEST_ARGS[@]}"
    fi
else
    echo -e "${GREEN}🚀 Running tests...${NC}"
    echo ""
    
    if [ ${#PYTEST_ARGS[@]} -eq 0 ]; then
        # No arguments, run all tests with verbose output
        pytest -v
    else
        # Pass all arguments to pytest
        pytest "${PYTEST_ARGS[@]}"
    fi
fi

# Capture exit code
TEST_EXIT_CODE=$?

echo ""
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    
    if [ "$COVERAGE" = true ]; then
        echo -e "${BLUE}📁 HTML report: $BACKEND_DIR/htmlcov/index.html${NC}"
        
        if [ "$OPEN_REPORT" = true ]; then
            echo -e "${GREEN}🌐 Opening coverage report in browser...${NC}"
            open htmlcov/index.html
        fi
    fi
else
    echo -e "${RED}❌ Some tests failed (exit code: $TEST_EXIT_CODE)${NC}"
fi

exit $TEST_EXIT_CODE
