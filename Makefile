#directories
BIN=./bin
SRC=./src
H=./include
#compilers
CC=clang++

GLM_H=$(H)/glm/
GLM_LIB=
#compiler options
CC_OUT=-o $(BIN)
CC_INCLUDE=-I$(H)/glm/ -I$(H) -I/home/reese/binaries/vulkan-1.3.236.0/x86_64/include/ -L/home/reese/binaries/vulkan-1.3.236.0/x86_64/lib/
LDFLAGS=-lglfw3 -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi
CFLAGS=-std=c++20 -Wall -02
build:
	$(CC) $(CC_INCLUDE) $(SRC)/main.cpp $(FLAGS) $(CC_OUT)/main.out $(LDFLAGS)

all: build

clean: $(BIN)/main.out
	rm $(BIN)/main.out
