RM := rm -rf
JAVA_HOME = /usr/lib/jvm/java-6-sun-1.6.0.20/

LIB_SO_JAVA = lib/libphotogrammetrie-java.so
LIB_SO = lib/libphotogrammetrie.so
C_TEST = lib/zugriff_photogrammetrie_c
JAR    = lib/photogrammetrie.jar

JAVA_DIR = java
LIB_DIR = lib

Basics = Basics/ebene.cpp Basics/point.cpp Basics/rot_matrix.cpp Basics/straight_line.cpp
Matrix = Basics/Matrix/matrix.cpp
Photo  = Photo/bpoint.cpp Photo/cam.cpp Photo/forward_intersection.cpp
Boreside = boreside_alignement/cam_bore.cpp boreside_alignement/boreside_transformation.cpp
Transformation = transformation/applanix.cpp transformation/rot_matrix_appl.cpp
Position = position/gps_pos.cpp

WRAPPER_JAVA = wrapper_for_java/CBPointList.cpp wrapper_for_java/Vorwaertsschnitt_java.cpp wrapper_for_java/mainwrapperjava.cpp internal_control/CPhotogrammetrieTest.cpp
WRAPPER_C = wrapper_for_c/photoST.cpp

PHOTOGRAMMETRIE_SOURCES = $(Basics) $(Matrix) $(Photo) $(Boreside) $(Transformation) $(Position)
JAVA_SOURCES = $(PHOTOGRAMMETRIE_SOURCES) $(WRAPPER_JAVA)
TEST_SOURCES = wrapper_for_c/example/zugriff_photogrammetrie_c.c

SWIG_JAVA_SOURCE = photogrammetrie-java.i
SWIG_LISP_SOURCE = photogrammetrie-lisp.i

SWIG_JAVA = photogrammetrie_wrap.cxx
SWIG_LISP = photo.lisp

HEADERS = $(wildcard */*.h)


all: $(LIB_SO) $(SWIG_LISP)

test: $(C_TEST)

clean:
	-$(RM) $(LIB_DIR) $(JAVA_DIR) $(SWIG_JAVA) $(SWIG_LISP) *.fasl

.PHONY: all clean

$(JAR): $(LIB_SO_JAVA)
	javac -encoding UTF-8 $(JAVA_DIR)/*.java
	jar cf $@ -C $(JAVA_DIR) ./

$(LIB_SO_JAVA): $(SWIG_JAVA)
	mkdir -p $(LIB_DIR)
	g++ -fpic -shared -I$(JAVA_HOME)/include  -I$(JAVA_HOME)/include/linux -o $@ $(JAVA_SOURCES)

$(LIB_SO): $(PHOTOGRAMMETRIE_SOURCES) $(WRAPPER_C) $(HEADERS)
	mkdir -p $(LIB_DIR)
	g++ -fpic -shared -o $@ $(PHOTOGRAMMETRIE_SOURCES) $(WRAPPER_C)

$(SWIG_JAVA): $(SWIG_JAVA_SOURCE) $(JAVA_SOURCES)
	mkdir -p $(JAVA_DIR)
	swig -c++ -java -package photogrammetrie -outdir $(JAVA_DIR) $(SWIG_JAVA_SOURCE)

$(SWIG_LISP): $(SWIG_LISP_SOURCE) $(PHOTOGRAMMETRIE_SOURCES) $(HEADERS)
	swig -cffi -outdir . $(SWIG_LISP_SOURCE)

$(C_TEST): $(LIB_SO) $(TEST_SOURCES) $(HEADERS)
	mkdir -p $(LIB_DIR)
	gcc -o $@ $(TEST_SOURCES) -L ./ $(LIB_SO)
