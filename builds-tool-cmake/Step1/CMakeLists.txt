
### Step 1 -- 初始化应用

# 
cmake_minimum_required(VERSION 3.10)

# set the project name
project(Hello VERSION 1.0)

# add the executable
add_executable(Hello hello.cc)


### Step 2 -- 自动生成头文件 ， 并且引用头文件声明内容

# 自动生成头文件 ，configure a header file to pass some of the CMake settings
# to the source code
configure_file(HelloConfig.h.in HelloConfig.h)

#  we must add that directory to the list of paths to search for include files. 增加搜索目录
target_include_directories(Hello PUBLIC "${PROJECT_BINARY_DIR}")


# ###  Step 3 --- 指定C++标准

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)



# Step 4 --- 封装和依赖外部库
# Now let us make the MathFunctions library optional. While for the tutorial there really isn't any need to do so, for larger projects this is a common occurrence. The first step is to add an option to the top-level CMakeLists.txt file
option(USE_MYMATH "Use tutorial provided math implementation" ON)

if(USE_MYMATH)
    # add the MathFunctions library
    add_subdirectory(MathFunctions)
    list(APPEND EXTRA_LIBS MathFunctions)
    list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
    target_link_libraries(Hello PUBLIC MathFunctions)
endif()


# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Hello PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${PROJECT_SOURCE_DIR}/MathFunctions"
                          )
