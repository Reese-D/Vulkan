#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#include <iostream>
#include <stdexcept>
#include <cstdlib>
#include <memory>
class BoardGame
{
    const uint32_t WIDTH = 800;
    const uint32_t HEIGHT = 600;
public:
    void run() {
        initWindow();
        initVulkan();
        mainLoop();
        cleanup();
    }

    BoardGame()
        : sp_window(nullptr, nullptr)
    {
    }
    
private:
    std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)> sp_window;
    void initWindow(){
        glfwInit();
        glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
        glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
        sp_window = std::unique_ptr<GLFWwindow, decltype(&glfwDestroyWindow)>(glfwCreateWindow(WIDTH, HEIGHT, "Vulkan", nullptr, nullptr), glfwDestroyWindow);
    }
    
    void initVulkan(){
        
    }

    void mainLoop(){
        while(!glfwWindowShouldClose(sp_window.get())){
                glfwPollEvents();
            }
    }

    void cleanup(){
        glfwTerminate();
    }
};

int main(int argc, char* argv[]){
    BoardGame app;

    try {
        app.run();
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

