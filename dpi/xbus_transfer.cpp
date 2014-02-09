

#include "xbus_transfer.h"
using namespace XBUS;

void XBUS_MailBox::push(XBUS_Transfer* tt) {
  m_vec.push_back(tt);
  m_it = m_vec.begin();
}

bool XBUS_MailBox::is_empty() {
  return m_vec.empty();
}

XBUS_Transfer* XBUS_MailBox::next() {
  XBUS_Transfer* tt;
  if (m_it != m_vec.end()){
    tt = *m_it;
    m_it++;
    return tt;
  }
  return NULL;
}

int XBUS_MailBox::size() {
  return m_vec.size();
}

