OUTPUT=vecAdd

CC=nvcc
CFLAGS=-arch=sm_50 -I/opt/cuda/include

$(OUTPUT): $(OUTPUT).cu
	$(CC) $(CFLAGS) $(OUTPUT).cu -o $(OUTPUT)

.PHONY: all
all:
	$(OUTPUT)

.PHONY: clean
clean:
	rm $(OUTPUT)
