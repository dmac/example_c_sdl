BUILD := build
SRC := $(wildcard *.c)
INC := $(wildcard *.h)
OBJ := $(SRC:%.c=$(BUILD)/%.o)
BIN := $(BUILD)/example

CFLAGS := -std=c99 -O2 -g -Wall -Werror -pedantic -F lib
LDFLAGS := -F lib -framework SDL2

.DEFAULT_GOAL := $(BIN)

$(BIN): $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)
	install_name_tool -add_rpath "@loader_path/../lib" $@

$(BUILD)/%.o: %.c | $(BUILD)
	$(CC) -c -o $@ $< $(CFLAGS)

$(BUILD)/depfile: $(SRC) $(INC) | $(BUILD)
	$(CC) -MM $(SRC) $(CFLAGS) | sed -e 's/^/$(BUILD)\//' > $@

$(BUILD):
	mkdir -p $@

-include $(BUILD)/depfile

.PHONY: clean
clean:
	rm -fr $(BUILD)

.PHONY: run
run: $(BIN)
	./$(BIN)
