

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
namespace XBUS {
  /* Base transfer */
  class Base_Transfer {
    public:
      Base_Transfer(){}
      ~Base_Transfer(){}
  };
  /* XBUS Transfer */
  class XBUS_Transfer : public Base_Transfer{
    public :
      XBUS_Transfer(){}
      ~XBUS_Transfer(){}
    public :
      unsigned long int begin_cycle;
      unsigned long int end_cycle;
      unsigned long int begin_time;
      unsigned long int end_time;
      unsigned long int addr;
      unsigned long int data;
      unsigned int byten;
      string rw;
  };

  template <class T>
    class Base_MailBox {
      public:
        Base_MailBox(){}
        ~Base_MailBox(){}
      public:
        typedef typename std::vector<T*>::iterator m_it;
        virtual void push(T*) = 0;
        virtual bool is_empty() = 0;
        virtual T* next() = 0;
        virtual int size() = 0;
      private:
        std::vector<T*> m_vec;
    };

  /* XBUS MailBox */
  class XBUS_MailBox : public Base_MailBox<XBUS_Transfer>{
    public:
      XBUS_MailBox(std::string inst_name): inst_name(inst_name){}
      ~XBUS_MailBox(){}
    public:
      typedef std::vector<XBUS_Transfer*>::iterator iter_vec;
      iter_vec m_it;
      void push(XBUS_Transfer*);
      bool is_empty();
      XBUS_Transfer* next();
      int size();
    private:
      std::vector<XBUS_Transfer*> m_vec;
      std::string inst_name;
  };
}
