OUTPUT=pipe_ls_wc

CC=gcc
CFLAGS=-Wall

$(OUTPUT): $(OUTPUT).c
	$(CC) -o $(OUTPUT) $(CFLAGS) $(OUTPUT).c

.PHONY: all
all:
	$(OUTPUT)

.PHONY: clean
clean:
	rm $(OUTPUT)
