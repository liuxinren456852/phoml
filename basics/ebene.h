#ifndef __EBENE_h
#define __EBENE_h

#include <list>

//#include "rot_matrix.h" //old
//#include "rotation_matrix.h"
#include "point.h"

#include "straight_line.h"

class Ebene
{
public:
 Ebene();
 Ebene(Point N,double D);
 Ebene(double nx,double ny,double nz,double D);
 Ebene(list<Point> &KooL);
 Ebene(const Ebene& E );
 ~Ebene();

 Ebene& operator= (const Ebene &E);

 bool operator== (const Ebene &E);


 Point  get_N() const;
 double get_D() const;
 
 double Abstand        (const Point &P);
 Gerade Schnitt        (Ebene  &E);
 Point  Durchstoss     (Gerade &G);
	
 Point  LotFussP       (Point &P);
 //double SchnittWinkel  (Ebene &E);
 //Point  Schnitt        (Ebene &E1,Ebene &E1);

 Ebene Rotation(Point& X0, Matrix& R);
 Ebene RotationRueck(Point& X0, Matrix& R);

 bool write(std::string &filename);
 bool read(std::string &filename);

private:

  Point m_n; //Normalenvektor (normal vector from the "Hessische Normalform")
  double m_p; //Abstand zum Koordinatenursprung (distance from the oringin point) ( math. p = |d| / ||n|| )

};

inline ostream& operator<<(ostream& s,const Ebene &E)
{
   int precision=5;       //Nachkommastellen   
   int vorkommastellen=8; //Minus zhlt als Vorkommastelle

   s.setf(ios::fixed|ios::showpoint, ios::floatfield);//<<showpoint<<fixed
   s.setf(ios::right, ios::adjustfield);
   s.precision(precision);

   //Point P=E.get_N();

   s<<"( n: "
	//<<setfill(' ')<<setw(precision+vorkommastellen+1)
	<<E.get_N()
	<<","
	<<" p:"
	<<setfill(' ')<<setw(precision+vorkommastellen+1)
	<<E.get_D()
	<<") ";

return s;
};

#endif
