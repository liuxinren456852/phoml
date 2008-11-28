VPATH = Basics GPS Matrix Photo

Swig   = photogrammetrie_wrap.cxx
Basics = ebene.cpp point.cpp rot_matrix.cpp straight_line.cpp
//GPS	   = GPS_orient.cpp picture_log.cpp
Matrix = Basics//Matrix//matrix.cpp
Photo  = bpoint.cpp cam.cpp forward_intersection.cpp
Boreside = boreside_alignement/cam_bore.cpp boreside_alignement/boreside_transformation.cpp
Wrapper = wrapper_for_java//CBPointList.cpp wrapper_for_java//Vorwaertsschnitt_java.cpp wrapper_for_java/mainwrapperjava.cpp wrapper_for_java/CPhotogrammetrieTest.cpp

photogrammetrie:	$(Swig) $(Basics) $(GPS) $(Matrix) $(Photo) $(Boreside) $(Wrapper)
	g++ -fpic -shared -I$(JAVA_HOME)/include  -I$(JAVA_HOME)/include/linux -o bin/libphotogrammetrie.so $^