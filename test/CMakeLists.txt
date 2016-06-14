include(VigraAddTest)

file(GLOB TEST_TARGETS test_*.cxx)

foreach(FILE ${TEST_TARGETS})
    GET_FILENAME_COMPONENT(TARGET ${FILE} NAME_WE)
    vigra_add_test(${TARGET} SOURCES ${FILE} LIBRARIES threadpool)
endforeach(FILE)
